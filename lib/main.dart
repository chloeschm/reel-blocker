import 'package:flutter/material.dart';
import 'package:reel_blocker/daily_stats.dart';
import 'package:reel_blocker/daily_stats_storage.dart';
import 'package:reel_blocker/streak_storage.dart';
import 'session.dart';
import 'session_storage.dart';
import 'hesitation_screen.dart';
import 'unlocked_screen.dart';
import 'notification_service.dart';
import 'reflection_screen.dart';
import 'recap_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  runApp(ReelBlockerApp());
}

class ReelBlockerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Reel Blocker', home: InterventionScreen());
  }
}

// *** INTERVENTION SCREEN ***
class InterventionScreen extends StatefulWidget {
  const InterventionScreen({Key? key}) : super(key: key);

  @override
  State<InterventionScreen> createState() => _InterventionScreenState();
}

class _InterventionScreenState extends State<InterventionScreen> {
  Session? session;
  DailyStats? dailyStats;
  int streak = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _resolveSession();
  }

  Future<void> _resolveSession() async {
    session = await SessionStorage.load();
    dailyStats = await DailyStatsStorage.load();
    streak = await StreakStorage.load();
    await NotificationService.scheduleDailyRecap();

    if (session == null) {
      session = Session(startTime: DateTime.now());
      await SessionStorage.save(session!);
    }

    dailyStats!.openHours.add(DateTime.now().hour);
    await DailyStatsStorage.save(dailyStats!);

    setState(() {
      loading = false;
    });
  }

  // BUTTONS
  Future<void> _chooseScroll() async {
    session!.choice = SessionChoice.scroll;
    session!.stage = SessionStage.hesitation;

    await SessionStorage.save(session!);

    dailyStats!.scrollCount++;
    await DailyStatsStorage.save(dailyStats!);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HesitationScreen(dailyStats: dailyStats!),
      ),
    );
  }

  Future<void> _chooseDM() async {
    session!.choice = SessionChoice.dm;
    session!.stage = SessionStage.unlocked;
    session!.unlockExpires = DateTime.now().add(const Duration(minutes: 30));

    await SessionStorage.save(session!);

    dailyStats!.dmCount++;
    await DailyStatsStorage.save(dailyStats!);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UnlockedScreen()),
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (NotificationService.shouldShowReflection && dailyStats != null) {
      NotificationService.shouldShowReflection = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReflectionScreen(dailyStats: dailyStats!),
          ),
        );
      });
    }

    if (NotificationService.shouldShowRecap && dailyStats != null) {
      NotificationService.shouldShowRecap = false;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final updatedStreak = await StreakStorage.checkAndUpdate(dailyStats!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecapScreen(
              dailyStats: dailyStats!,
              streak: updatedStreak,
            ),
          ),
        );
      });
    }

    return _buildQuestionScreen();
  }

  Widget _buildQuestionScreen() {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 193, 155, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'JACK!! why are you opening Instagram!!?',
              style: TextStyle(color: Colors.white, fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _chooseScroll,
              child: const Text('going to DOOMSCROLL'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _chooseDM,
              child: const Text('checking our dms'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'session.dart';
import 'session_storage.dart';

void main() {
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
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _resolveSession();
  }

  Future<void> _resolveSession() async {
    session = await SessionStorage.load();

    if (session == null) {
      session = Session(startTime: DateTime.now());
      await SessionStorage.save(session!);
    }

    setState(() {
      loading = false;
    });
  }

  // BUTTONS
  Future<void> _chooseScroll() async {
    session!.choice = SessionChoice.scroll;
    session!.stage = SessionStage.hesitation;

    await SessionStorage.save(session!);

    Navigator.push(context, MaterialPageRoute(builder: (context) => HesitationScreen()));
  }

  Future<void> _chooseDM() async {
    session!.choice = SessionChoice.dm;
    session!.stage = SessionStage.unlocked;
    session!.unlockExpires = DateTime.now().add(const Duration(minutes: 30));

    await SessionStorage.save(session!);

    print("Go to unlock screen");
  }

  // UI
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return _buildQuestionScreen();
  }

  Widget _buildQuestionScreen() {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'JACK!! why are you opening Instagram!!?',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _chooseScroll,
              child: const Text('going to DOOMSCROLL'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _chooseDM,
              child: const Text('checking our DMs'),
            ),
          ],
        ),
      ),
    );
  }
}

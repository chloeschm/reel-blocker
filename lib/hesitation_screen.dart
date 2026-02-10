import 'package:flutter/material.dart';
import 'daily_stats.dart';
import 'unlocked_screen.dart';

class HesitationScreen extends StatefulWidget {
  final DailyStats dailyStats;

  const HesitationScreen({Key? key, required this.dailyStats})
    : super(key: key);

  @override
  State<HesitationScreen> createState() => _HesitationScreenState();
}

class _HesitationScreenState extends State<HesitationScreen> {
  int secondsRemaining = 10;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _confirmScroll() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UnlockedScreen(),
      ),
      );
    print("confirmed scroll :(");
  }

  void _startCountdown() {
    Future.delayed(Duration(seconds: 1), () {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
        _startCountdown();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'are you SURE ??',
              style: TextStyle(color: Colors.white, fontSize: 32),
            ),
            SizedBox(height: 20),

            if (widget.dailyStats.scrollCount > 5)
              Text(
                "you've already scrolled ${widget.dailyStats.scrollCount} times today...",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            SizedBox(height: 40),
            Text(
              secondsRemaining > 0
                  ? 'really think for $secondsRemaining seconds...'
                  : 'okay...go ahead i guess',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: secondsRemaining > 0 ? null : _confirmScroll,
              child: Text('yes, i\'m sure'),
            ),
          ],
        ),
      ),
    );
  }
}

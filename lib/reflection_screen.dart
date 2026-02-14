import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'daily_stats.dart';
import 'daily_stats_storage.dart';

class ReflectionScreen extends StatelessWidget {
  final DailyStats dailyStats;  
  
  const ReflectionScreen({Key? key, required this.dailyStats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,  
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'was it worth it?',
              style: TextStyle(color: Colors.white, fontSize: 32),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async { 
                dailyStats.worthItYes++;
                await DailyStatsStorage.save(dailyStats);  
                SystemNavigator.pop();
              },
              child: const Text('yes'), 
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {  
                dailyStats.worthItNo++;
                await DailyStatsStorage.save(dailyStats);  
                SystemNavigator.pop();
              },
              child: const Text('no'),  
            ),
          ],
        ),
      ),
    );
  }
}
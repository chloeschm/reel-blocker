import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'daily_stats.dart';

class RecapScreen extends StatelessWidget {
  final DailyStats dailyStats;
  final int streak;

  const RecapScreen({
    Key? key,
    required this.dailyStats,
    required this.streak,
  }) : super(key: key);

  int? _findPeakHour() {
    if (dailyStats.openHours.isEmpty) return null;

    Map<int, int> hourCounts = {};
    for (var hour in dailyStats.openHours) {
      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
    }

    return hourCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  String _formatHour(int hour) {
    if (hour == 0) return '12 AM';
    if (hour < 12) return '$hour AM';
    if (hour == 12) return '12 PM';
    return '${hour - 12} PM';
  }

  String _formatDate(DateTime date) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 
                    'July', 'August', 'September', 'October', 'November', 'December'];
    
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final totalOpens = dailyStats.scrollCount + dailyStats.dmCount;
    final peakHour = _findPeakHour();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 43, 148, 110),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'DAILY RECAP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              Text(
                _formatDate(dailyStats.date),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 32),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildStatCard(
                        'Total Opens',
                        '$totalOpens',
                        Icons.phone_android,
                      ),
                      const SizedBox(height: 16),

                      _buildStatCard(
                        'For DMs:',
                        '${dailyStats.dmCount}',
                        Icons.message,
                        subtitle: 'For Scrolling: ${dailyStats.scrollCount}',
                      ),
                      const SizedBox(height: 16),

                      _buildStatCard(
                        'Scroll Streak',
                        '$streak days',
                        Icons.local_fire_department,
                        subtitle: streak > 0 
                            ? 'days scrolling > dming in a row'
                            : 'higher dm rate breaks the streak',
                      ),
                      const SizedBox(height: 16),

                      if (peakHour != null)
                        _buildStatCard(
                          'Peak Hour',
                          _formatHour(peakHour),
                          Icons.access_time,
                          subtitle: 'you opened instagram most at this time',
                        ),
                      const SizedBox(height: 16),

                      if (dailyStats.worthItYes > 0 || dailyStats.worthItNo > 0)
                        _buildStatCard(
                          'Was it Worth it ?',
                          'yes: ${dailyStats.worthItYes}  no: ${dailyStats.worthItNo}',
                          Icons.thumbs_up_down,
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    'close recap',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable stat card widget
  Widget _buildStatCard(String title, String value, IconData icon, {String? subtitle}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
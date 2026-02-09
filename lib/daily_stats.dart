class DailyStats {
  final DateTime date;
  int scrollCount;
  int dmCount;

  DailyStats({required this.date, this.scrollCount = 0, this.dmCount = 0});

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'scrollCount': scrollCount,
      'dmCount': dmCount,
    };
  }

  factory DailyStats.fromMap(Map<String, dynamic> map) {
    return DailyStats(
      date: DateTime.parse(map['date']),
      scrollCount: map['scrollCount'] as int,
      dmCount: map['dmCount'] as int,
    );
  }
}

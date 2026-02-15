class DailyStats {
  final DateTime date;
  int scrollCount;
  int dmCount;
  int worthItYes;
  int worthItNo;
  List<int> openHours;

  DailyStats({
    required this.date,
    this.scrollCount = 0,
    this.dmCount = 0,
    this.worthItYes = 0,
    this.worthItNo = 0,
    this.openHours = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'scrollCount': scrollCount,
      'dmCount': dmCount,
      'worthItYes': worthItYes,
      'worthItNo': worthItNo,
      'openHours': openHours,
    };
  }

  factory DailyStats.fromMap(Map<String, dynamic> map) {
    return DailyStats(
      date: DateTime.parse(map['date']),
      scrollCount: map['scrollCount'] as int,
      dmCount: map['dmCount'] as int,
      worthItYes: map['worthItYes'] as int,
      worthItNo: map['worthItNo'] as int,
      openHours: map['openHours'] != null
          ? (map['openHours'] as List<dynamic>).map((e) => e as int).toList()
          : [],
    );
  }
}

enum SessionStage { question, hesitation, unlocked, finished }

enum SessionChoice { none, dm, scroll }

class Session {
  final DateTime startTime;
  SessionStage stage;
  SessionChoice choice;
  DateTime? unlockExpires;

  Session({
    required this.startTime,
    this.stage = SessionStage.question,
    this.choice = SessionChoice.none,
    this.unlockExpires,
  });

  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime.toIso8601String(),
      'stage': stage.index,
      'choice': choice.index,
      'unlockExpires': unlockExpires?.toIso8601String(),
    };
  } 

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      startTime: DateTime.parse(map['startTime']),
      stage: SessionStage.values[map['stage']],
      choice: SessionChoice.values[map['choice']],
      unlockExpires: map['unlockExpires'] != null
          ? DateTime.parse(map['unlockExpires'])
          : null,
    );
  }
}

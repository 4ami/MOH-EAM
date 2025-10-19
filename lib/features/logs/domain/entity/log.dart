final class LogEntity {
  final String state;
  final String? actionBy, targetUser, note;
  final String loggedAt;

  const LogEntity({
    required this.state,
    this.actionBy,
    this.targetUser,
    this.note,
    required this.loggedAt,
  });

  String get loggedAtFormatted {
    DateTime dt = DateTime.parse(loggedAt);
    String formatted =
        "${dt.year.toString().padLeft(4, '0')}-"
        "${dt.month.toString().padLeft(2, '0')}-"
        "${dt.day.toString().padLeft(2, '0')} "
        "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}";
    return formatted;
  }
}

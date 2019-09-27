class Messages {
  final String content;
  final String idFrom;
  final String idTo;
  final DateTime timestamp;
  final int type; // 0 - TEXT, 1 - IMAGE, 2 - STICKER

  Messages({this.content, this.idFrom, this.idTo, this.timestamp, this.type});

  static List<Messages> message = [
    Messages(
        content: 'Hello',
        idFrom: 'userID123',
        idTo: 'userID345',
        timestamp: DateTime.now(),
        type: 0),
    Messages(
        content: 'World',
        idFrom: 'userID123',
        idTo: 'userID345',
        timestamp: DateTime.now(),
        type: 0),
    Messages(
        content: 'Flutter',
        idFrom: 'userID123',
        idTo: 'userID345',
        timestamp: DateTime.now(),
        type: 0),
    Messages(
        content: 'Recommendation',
        idFrom: 'userID123',
        idTo: 'userID345',
        timestamp: DateTime.now(),
        type: 0),
    Messages(
        content: 'System',
        idFrom: 'userID123',
        idTo: 'userID345',
        timestamp: DateTime.now(),
        type: 0),
    Messages(
        content: 'System',
        idFrom: 'userID123',
        idTo: 'userID345',
        timestamp: DateTime.now(),
        type: 0),
  ];
}

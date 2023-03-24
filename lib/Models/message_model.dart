class GroupMsgModel {
  final String message;
  bool isRead = false;
  final String time;
  final String sendby;
  final String username;
  final String? image;

  GroupMsgModel({
    required this.image,
    required this.message,
    required this.time,
    required this.sendby,
    this.isRead = false,
    required this.username,
  });
}

import 'package:injectable/injectable.dart';

@LazySingleton()
class GroupModel {
  final String groupId;
  final String name;
  bool adminOnlyMessage = false;
  String? photo;
  String? lastMsg;
  String? sendby;

  GroupModel(
      {required this.name,
      required this.groupId,
      required this.adminOnlyMessage,
      this.photo,
      this.lastMsg,
      this.sendby});
}

class GroupMember {
  final String uid;
  String? username;
  String email;
  String? photo;
  bool isAdmin;
  bool isOwner;

  GroupMember(
      {required this.uid,
      required this.username,
      required this.email,
      this.photo,
      this.isAdmin = false,
      this.isOwner = false});
}

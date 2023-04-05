import 'package:flutter/material.dart';

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

//personal message model
class PersonalMsgModel {
  final String message;
  bool isRead = false;
  final String time;
  final String sendby;
  String? username;
  final String? image;
  final String messageType;

  PersonalMsgModel(
      {required this.image,
      required this.message,
      required this.time,
      required this.sendby,
      this.isRead = false,
      required this.messageType});
}

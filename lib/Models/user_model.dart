import 'package:chatbot/util.dart';

class Bot {
  String uid;
  String? username;
  String email;
  String? photo;
  BotsState state;
  Bot(
      {required this.uid,
      required this.email,
      this.photo,
      this.username,
      required this.state});
}

class Profile {
  String uid;
  String? username;
  String email;
  String? photo;

  Profile({
    required this.uid,
    required this.email,
    this.photo,
    this.username,
  });
}

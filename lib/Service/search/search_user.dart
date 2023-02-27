import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

class SearchUser {
  final database = FirebaseDatabase.instance.ref("users");
  Future onSearch(String query) async {
    final user = await database.get();

    for (var element in user.children) {
      element.children.forEach((element) {
        log(element.toString());
      });
    }
  }
}

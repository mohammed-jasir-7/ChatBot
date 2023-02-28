import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';

class SearchUser {
  final database = FirebaseDatabase.instance.ref();
  Future onSearch(String query) async {
    final user = await database.child('users').get();

    // log(user.children.first['email'] as String);
  }
}

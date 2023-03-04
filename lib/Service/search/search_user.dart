import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class SearchUser {
  final database = FirebaseFirestore.instance.collection("users").snapshots();
  Future onSearch() async {
    final user = await database.listen((event) {
      log(event.docs.toString());
    });

    // log(user.children.first['email'] as String);
  }
}

import 'dart:developer';
import 'package:chatbot/Models/user_model.dart';
import 'package:chatbot/views/new%20chat%20screen/widgets/user_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../util.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final List<Bot> users = [];
  final List<Bot> connections = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backroundColor,
        centerTitle: true,
        title: Image.asset("assets/images/logoText.png"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: backroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
//stream builder
//listen users collecion firestore
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                log("Strream building");

                if (snapshot.hasData) {
                  users.clear();
                  for (var element in snapshot.data!.docs) {
                    if (FirebaseAuth.instance.currentUser!.uid !=
                        element.reference.id) {
                      users.add(Bot(
                          uid: element.reference.id,
                          email: element.get('email'),
                          username: element.get('userName') ?? "",
                          photo: element.get('photo')));
                    }
                  }
                  return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("connections")
                          .snapshots(),
                      builder: (context, snapshot) {
                        connections.clear();
                        if (snapshot.hasData) {
                          for (var connection in snapshot.data!.docs) {
                            for (var bot in users) {
                              if (bot.uid == connection.get('botid')) {
                                log("message${bot.uid}");
                                connections.add(bot);
                              }
                            }
                          }
                          log("connectios length ${connections.length}");
                          return UsersListInContact(
                            users: connections,
                            iscontactScreen: false,
                          );
                        }

                        return Center(child: CircularProgressIndicator());
                      });
                }

                return CircularProgressIndicator();
              }),
        ),
      ),
    );
  }
}

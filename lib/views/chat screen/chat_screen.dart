import 'dart:developer';
import 'package:chatbot/Controllers/group%20chat%20bloc/group_bloc.dart';
import 'package:chatbot/Models/user_model.dart';
import 'package:chatbot/views/chat%20screen/widget/group_list.dart';
import 'package:chatbot/views/new%20chat%20screen/widgets/user_list.dart';
import 'package:chatbot/views/new%20group%20screen/new_group_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../util.dart';
import '../common/widgets/custom_text.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final List<Bot> users = [];
  final List<Bot> connections = [];
  ValueNotifier<bool> isVisible = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    log("chat screeen");
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(60.0),
          //floationg action button
          child: ValueListenableBuilder(
            valueListenable: isVisible,
            builder: (context, value, child) => value
                ? FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewGroupScreen(
                              connections: connections,
                              isAddMemberScreen: false,
                            ),
                          ));
                    },
                    child: const Icon(Icons.group_add),
                  )
                : const SizedBox.shrink(),
          ),
        ),
        appBar: AppBar(
          bottom: TabBar(
              onTap: (value) {
                if (value == 1) {
                  isVisible.value = true;
                } else {
                  isVisible.value = false;
                }
              },
              unselectedLabelColor: colorWhite.withOpacity(0.5),
              isScrollable: true,
              splashBorderRadius: BorderRadius.circular(30),
              labelColor: colorWhite,
              dividerColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              tabs: [
                const Tab(child: CustomText(content: "Friends")),
                Tab(
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 50),
                    child: Row(
                      children: const [
                        CustomText(content: "Groups"),
                      ],
                    ),
                  ),
                ),
              ]),
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
                  if (snapshot.hasData) {
                    users.clear();
                    for (var element in snapshot.data!.docs) {
                      if (FirebaseAuth.instance.currentUser!.uid !=
                          element.reference.id) {
                        users.add(Bot(
                            uid: element.reference.id,
                            email: element.data()["email"],
                            username: element.data()["userName"] ?? "",
                            photo: element.data()["photo"],
                            state: BotsState.connect));
                      }
                    }
                    // listen connections
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
                                  connections.add(bot);
                                }
                              }
                            }

                            //tabar view
                            return TabBarView(
                              children: [
                                UsersListInContact(
                                  users: connections,
                                  iscontactScreen: false,
                                ),
                                GroupList()
                              ],
                            );
                          }

                          return const Center(
                              child: CircularProgressIndicator());
                        });
                  }

                  return const CircularProgressIndicator();
                }),
          ),
        ),
      ),
    );
  }
}

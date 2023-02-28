import 'dart:developer';
import 'package:chatbot/Controllers/search%20bloc/search_bloc.dart';
import 'package:chatbot/Models/user_model.dart';
import 'package:chatbot/views/individual%20chat%20screen/individual_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../util.dart';
import '../common/widgets/custom_text.dart';
import '../common/widgets/textformcommon_style.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});
  final _textEditingcontroller = TextEditingController();
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
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                List<User> users = [];
                if (snapshot.hasData) {
                  snapshot.data!.docs.forEach((element) {
                    users.add(User(
                        uid: element.reference.id,
                        email: element.get('email'),
                        photo: element.get("photo"),
                        username: element.get('userName')));
                    log(users.first.username.toString());
                  });
                }

                return Column(
                  children: [
                    SizedBox(
                      width: 300,
                      height: 35,
                      child: TextField(
                        autofocus: false,
                        onTapOutside: (event) {
                          log("textfielt on tap outside");
                        },
                        onTap: () {
                          log("textfielt on tap");
                        },
                        controller: _textEditingcontroller,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(color: colorSearchBartext),
                        decoration: searchBarStyle(),
                        onChanged: (value) async {
                          final bb = users
                              .where((element) => element.email.contains(value))
                              .toList();
                          log(users.length.toString());

                          context
                              .read<SearchBloc>()
                              .add(SearchingEvent(query: value));
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                          physics: const BouncingScrollPhysics(
                              decelerationRate: ScrollDecelerationRate.fast),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => IndividualChatScreen(),
                                ));
                              },
                              child: ListTile(
                                leading: const CircleAvatar(),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
                                    CircleAvatar(
                                      backgroundColor: Colors.green,
                                      radius: 10,
                                      child: Center(
                                          child: CustomText(
                                        content: "1",
                                        colour: colorSearchBartext,
                                        size: 10,
                                      )),
                                    ),
                                    CustomText(content: "5:11")
                                  ],
                                ),
                                title: CustomText(
                                  content: users[index].email,
                                  colour: colorWhite,
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: users.length),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

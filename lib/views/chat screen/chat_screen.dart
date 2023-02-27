import 'dart:convert';
import 'dart:developer';

import 'package:chatbot/Controllers/search%20bloc/search_bloc.dart';
import 'package:chatbot/Service/search/search_user.dart';
import 'package:chatbot/views/individual%20chat%20screen/individual_chat_screen.dart';
import 'package:firebase_database/firebase_database.dart';
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
          child: Column(
            children: [
              SizedBox(
                width: 300,
                height: 35,
                child: TextField(
                  controller: _textEditingcontroller,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(color: colorSearchBartext),
                  decoration: searchBarStyle(),
                  onChanged: (value) {
                    final js = SearchUser();
                    // js.onSearch(value);
                    context
                        .read<SearchBloc>()
                        .add(SearchingEvent(query: value));
                  },
                ),
              ),
              Expanded(
                child: StreamBuilder<DatabaseEvent>(
                    stream:
                        FirebaseDatabase.instance.ref().child("users").onValue,
                    builder: (context, snapshot) {
                      final bb = SearchUser();
                      bb.onSearch("hh");
                      return ListView.separated(
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
                                title: const CustomText(
                                  content: "User name",
                                  colour: colorWhite,
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: 50);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

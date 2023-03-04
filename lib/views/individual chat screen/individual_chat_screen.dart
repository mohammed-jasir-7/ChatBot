import 'dart:developer';

import 'package:chatbot/Controllers/chat%20bloc/chat_bloc.dart';
import 'package:chatbot/util.dart';
import 'package:chatbot/views/common/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../Models/user_model.dart';

ValueNotifier<bool> isWatcing = ValueNotifier(false);

class IndividualChatScreen extends StatefulWidget {
  IndividualChatScreen({super.key, required this.bot, required this.roomID});
  final Bot bot;
  final String roomID;

  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen>
    with WidgetsBindingObserver {
  final _messageController = TextEditingController();

  final _currentuser = FirebaseAuth.instance.currentUser;

  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    try {
      FirebaseFirestore.instance
          .collection('chatroom')
          .doc(widget.roomID)
          .update({FirebaseAuth.instance.currentUser!.uid: true});
    } on FirebaseException catch (e) {
      log(e.code);
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    FirebaseFirestore.instance
        .collection('chatroom')
        .doc(widget.roomID)
        .update({FirebaseAuth.instance.currentUser!.uid: false});
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      log("resumed");
      await FirebaseFirestore.instance
          .collection('chatroom')
          .doc(widget.roomID)
          .update({FirebaseAuth.instance.currentUser!.uid: true});
    } else if (state == AppLifecycleState.paused) {
      FirebaseFirestore.instance
          .collection('chatroom')
          .doc(widget.roomID)
          .update({FirebaseAuth.instance.currentUser!.uid: false});
      log("paused");
    } else if (state == AppLifecycleState.inactive) {
      FirebaseFirestore.instance
          .collection('chatroom')
          .doc(widget.roomID)
          .update({FirebaseAuth.instance.currentUser!.uid: false});
      log("inactive");
    } else if (state == AppLifecycleState.detached) {
      log("ditached");
    } else {
      log(state.toString());
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: backroundColor,
      appBar: AppBar(
        backgroundColor: backroundColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: colorWhite,
            )),
        title: CustomText(
          content: widget.bot.email,
          colour: colorWhite,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Center(child: CircleAvatar(radius: 19)),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: backroundColor,
        child: SizedBox(
          child: Stack(children: [
            Center(
              child: Image.asset(
                "assets/images/doodle2.png",
                width: double.infinity,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("chatroom")
                          .doc(widget.roomID)
                          .collection("chats")
                          .orderBy("time", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            controller: _scrollController,
                            reverse: true,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Message(
                                message: snapshot.data!.docs[index],
                                uID: _currentuser!.uid,
                              );
                            },
                            itemCount: snapshot.data!.docs.length,
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('chatroom')
                        .doc(widget.roomID)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!.data()![widget.bot.uid] ==
                                    false ||
                                snapshot.data!.data()![widget.bot.uid] == null
                            ? const SizedBox()
                            : Image.asset(
                                "assets/images/isWatching.png",
                                width: 60,
                              );
                      } else {
                        return const SizedBox();
                      }
                    }),
                Container(
                    decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: BorderRadius.circular(10)),
                    margin:
                        const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 260,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: TextField(
                                controller: _messageController,
                                style: GoogleFonts.poppins(
                                    decoration: TextDecoration.none),
                                decoration: textfieldDecoration(),
                              ),
                            )),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              context.read<ChatBloc>().add(SendMessageEvent(
                                  messages: _messageController.text,
                                  roomID: widget.roomID));
                              _messageController.clear();
                              _scrollController.animateTo(
                                0.0,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 300),
                              );
                            },
                            icon: const Icon(
                              Icons.send,
                              color: colorlogo,
                            ))
                      ],
                    )),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  InputDecoration textfieldDecoration() {
    return const InputDecoration(
        disabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        hintText: "Type here ......",
        border: InputBorder.none,
        errorBorder: InputBorder.none);
  }
}

class Message extends StatelessWidget {
  Message({super.key, required this.message, required this.uID});
  QueryDocumentSnapshot<Map<String, dynamic>> message;
  final String uID;

  @override
  Widget build(BuildContext context) {
    String date = message['time'] == null
        ? "time"
        : DateFormat.jm()
            .format((message['time'] as Timestamp).toDate())
            .toString();

    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
      child: Container(
          alignment: message['sendby'] == uID
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: message['sendby'] == uID
                  ? colorMessageCurrentuser
                  : colorMessageClientuser,
            ),
            constraints: const BoxConstraints(minWidth: 20, maxWidth: 200),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  CustomText(
                    content: message["message"],
                    size: 15,
                    colour: message['sendby'] == uID
                        ? colorMessageClientTextWhite
                        : colorMessageClientText,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        content: date,
                        size: 11,
                        colour: message['sendby'] == uID
                            ? colorMessageClientTextWhite.withOpacity(0.5)
                            : colorMessageClientText.withOpacity(0.5),
                      ),
                      Icon(
                        Icons.done_all,
                        color: colorMessageClientTextWhite.withOpacity(0.5),
                        size: 15,
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}

import 'dart:developer';
import 'package:chatbot/Controllers/chat%20bloc/chat_bloc.dart';
import 'package:chatbot/Models/message_model.dart';
import 'package:chatbot/util.dart';
import 'package:chatbot/views/individual_chat_screen/widgets/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import '../../Models/user_model.dart';
import '../common/widgets/custom_text.dart';
import 'widgets/appbar.dart';

ValueNotifier<bool> isWatcing = ValueNotifier(false);

class IndividualChatScreen extends StatefulWidget {
  const IndividualChatScreen(
      {super.key, required this.bot, required this.roomID});
  final Bot bot;
  final String roomID;

  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen>
    with WidgetsBindingObserver {
  final _messageController = TextEditingController();

  final _currentuser = FirebaseAuth.instance.currentUser;

  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    context.read<ChatBloc>().add(ChatLoadingEvent(widget.roomID));
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
    log("ivduvidual screeeeeen");
    return Scaffold(
      extendBody: true,
      backgroundColor: backroundColor,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBarForChat(bot: widget.bot)),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: backroundColor,
        child: SizedBox(
          child: Stack(children: [
            Image.asset(
              "assets/images/doodle2.png",
              width: double.infinity,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, snapshot) {
                    log(snapshot.toString());
                    if (snapshot is PovideAllMessageState) {
                      return ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          String previousDate = index <
                                  snapshot.allMessages.length - 1
                              ? DateFormat.yMMMMEEEEd().format((DateTime.parse(
                                  snapshot.allMessages[index + 1].time)))
                              : "";
                          log("$index ${snapshot.allMessages.length - 1}${snapshot.allMessages[index].message}  $previousDate");
                          String date = DateFormat.yMMMMEEEEd().format(
                              DateTime.parse(snapshot.allMessages[index].time));
                          log(previousDate);
                          return previousDate != date
                              ? dateDivider(snapshot.allMessages[index],
                                  _currentuser!.uid)
                              : Message(
                                  message: snapshot.allMessages[index],
                                  uID: _currentuser!.uid,
                                );
                        },
                        itemCount: snapshot.allMessages.length,
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
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
                        return snapshot.data != null &&
                                snapshot.data!.data() != null
                            ? snapshot.data!.data()![widget.bot.uid] == false ||
                                    snapshot.data!.data()![widget.bot.uid] ==
                                        null
                                ? const SizedBox()
                                : Image.asset(
                                    "assets/images/isWatching.png",
                                    width: 60,
                                  )
                            : const SizedBox();
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

StickyHeaderBuilder dateDivider(PersonalMsgModel state, String currentUser) {
  return StickyHeaderBuilder(
    builder: (context, stuckAmount) {
      String dateofChat = state.time;
      DateTime convertedDate = DateTime.parse(state.time);
      if (convertedDate.day == DateTime.now().day &&
          convertedDate.month == DateTime.now().month &&
          convertedDate.year == DateTime.now().year) {
        dateofChat = "Today";
      } else if (convertedDate.day ==
              DateTime.now().subtract(const Duration(days: 1)).day &&
          convertedDate.month == DateTime.now().month &&
          convertedDate.year == DateTime.now().year) {
        dateofChat = "Yesterday";
      } else {
        dateofChat = DateFormat.yMMMMEEEEd().format(convertedDate);
      }

      return Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 13),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: colorSearchBarFilled),
          child: CustomText(
            content: dateofChat,
            colour: colorMessageClientTextWhite,
            size: 13,
          ),
        ),
      );
    },
    content: Message(
      message: state,
      uID: currentUser,
    ),
  );
}

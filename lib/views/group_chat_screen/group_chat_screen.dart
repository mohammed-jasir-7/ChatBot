import 'dart:developer';
import 'package:chatbot/Controllers/message%20permission/msgpermission_cubit.dart';
import 'package:chatbot/views/common/widgets/custom_text.dart';
import 'package:chatbot/views/group_chat_screen/widget/group_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import '../../Controllers/gchat bloc/gchat_bloc.dart';
import '../../Models/group_model.dart';
import '../../util.dart';
import '../group_info/group_info_screen.dart';
import 'widget/appbar_group.dart';

class GroupChatScreen extends StatelessWidget {
  GroupChatScreen({super.key, required this.groupData});
  final GroupModel groupData;

  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    return Scaffold(
      extendBody: true,
      backgroundColor: backroundColor,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        GrpupInfoScreen(groupInfo: groupData)),
              );
            },
            child: AppBarForGroup(
              groupData: groupData,
            ),
          )),
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
                  child: BlocBuilder<GchatBloc, GchatState>(
                    builder: (BuildContext context, state) {
                      if (state is AllMessageState) {
                        return state.allmessages != null
                            ? ListView.builder(
                                controller: _scrollController,
                                reverse: true,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  String previousDate =
                                      index < state.allmessages.length - 1
                                          ? DateFormat.yMMMMEEEEd().format(
                                              DateTime.parse(state
                                                  .allmessages[index + 1].time))
                                          : "";

                                  String date = DateFormat.yMMMMEEEEd().format(
                                      DateTime.parse(
                                          state.allmessages[index].time));
                                  log("$date kkk $previousDate");
                                  return previousDate != date
                                      ? dateDivider(state, index, currentUser)
                                      : GroupMessage(
                                          message: state.allmessages[index],
                                          uID: currentUser,
                                          currentUsername:
                                              state.currentUsername,
                                        );
                                },
                                itemCount: state.allmessages.length,
                              )
                            : const CircularProgressIndicator();
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                BlocProvider(
                  create: (context) => MsgpermissionCubit(
                      firebaseAuth: FirebaseAuth.instance,
                      groupId: groupData.groupId,
                      firestore: FirebaseFirestore.instance),
                  child: BlocBuilder<MsgpermissionCubit, MsgpermissionState>(
                      builder: (context, state) {
                    if (state is PermissionState) {
                      if (state.permission == MsgPermisson.allow) {
                        return messagePanel(context);
                      } else {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                              right: 20, left: 20, bottom: 20),
                          decoration: BoxDecoration(
                              color: colorlogo,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: CustomText(
                              content: "only admins can send messages",
                              colour: colorWhite,
                            ),
                          ),
                        );
                      }
                    } else {
                      return Text("loading");
                    }
                  }),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }

  StickyHeaderBuilder dateDivider(
      AllMessageState state, int index, String currentUser) {
    return StickyHeaderBuilder(
      builder: (context, stuckAmount) {
        String dateofChat = state.allmessages[index].time;
        DateTime convertedDate = DateTime.parse(state.allmessages[index].time);
        if (convertedDate.day == DateTime.now().day &&
            convertedDate.month == DateTime.now().month &&
            convertedDate.year == DateTime.now().year) {
          dateofChat = "Today";
        } else if (convertedDate.day ==
                DateTime.now().subtract(Duration(days: 1)).day &&
            convertedDate.month == DateTime.now().month &&
            convertedDate.year == DateTime.now().year) {
          dateofChat = "Yesterday";
        } else {
          dateofChat = DateFormat.yMMMMEEEEd().format(convertedDate);
        }

        return Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 13),
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
      content: GroupMessage(
        message: state.allmessages[index],
        uID: currentUser,
        currentUsername: state.currentUsername,
      ),
    );
  }

  Widget messagePanel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: colorWhite, borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
      child: Row(
        children: [
          SizedBox(
              width: 260,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: TextField(
                  controller: _messageController,
                  style: GoogleFonts.poppins(decoration: TextDecoration.none),
                  decoration: textfieldDecoration(),
                ),
              )),
          const Spacer(),
          IconButton(
              onPressed: () {
                context.read<GchatBloc>().add(SendMessageEvent(
                    groupId: groupData.groupId,
                    message: _messageController.text));
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
      ),
    );
  }
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

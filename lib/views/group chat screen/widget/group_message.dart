import 'package:chatbot/Models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../util.dart';
import '../../common/widgets/custom_text.dart';

class GroupMessage extends StatelessWidget {
  const GroupMessage(
      {super.key,
      required this.message,
      required this.uID,
      required this.currentUsername});
  final GroupMsgModel message;
  final String uID;
  final String currentUsername;

  @override
  Widget build(BuildContext context) {
    // String date = message['time'] == null
    //     ? "time"
    //     : DateFormat.jm()
    //         .format((message['time'] as Timestamp).toDate())
    //         .toString();

    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
      child: Container(
          alignment: message.sendby == FirebaseAuth.instance.currentUser!.uid
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: message.sendby == uID
                  ? colorMessageCurrentuser
                  : colorMessageClientuser,
            ),
            constraints: const BoxConstraints(
                minWidth: 40, minHeight: 30, maxWidth: 200),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Column(
                children: [
                  message.sendby == uID
                      ? const SizedBox.shrink()
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundImage: message.image == null
                                  ? const AssetImage(nullPhoto) as ImageProvider
                                  : NetworkImage(message.image ?? ""),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            CustomText(
                                content: message.username,
                                size: 15,
                                colour: Colors.deepOrangeAccent),
                          ],
                        ),
                  CustomText(
                    content: message.message,
                    size: 15,
                    colour: message.sendby == uID
                        ? colorMessageClientTextWhite
                        : colorMessageClientText,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        content: message.time,
                        size: 11,
                        colour: message.sendby == uID
                            ? colorMessageClientTextWhite.withOpacity(0.5)
                            : colorMessageClientText.withOpacity(0.5),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}

import 'package:chatbot/Models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../util.dart';
import '../../common/widgets/custom_text.dart';

class Message extends StatelessWidget {
  const Message({super.key, required this.message, required this.uID});
  final PersonalMsgModel message;
  final String uID;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
      child: message.messageType == "msg"
          ? Container(
              alignment: message.messageType == "msg"
                  ? message.sendby == uID
                      ? Alignment.centerRight
                      : Alignment.centerLeft
                  : Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: message.sendby == uID
                      ? colorMessageCurrentuser
                      : colorMessageClientuser,
                ),
                constraints: const BoxConstraints(minWidth: 20, maxWidth: 200),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
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
                            content: DateFormat.jm()
                                .format(DateTime.parse(message.time)),
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
              ))
          : Container(
              alignment: Alignment.center,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: colorlogo.withOpacity(0.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //local side
                            if (message.sendby == uID)
                              Icon(
                                Icons.call_missed_outgoing,
                                color:
                                    message.isRead ? successColor : errorColor,
                              ),
                            if (message.sendby == uID)
                              CustomText(
                                content: message.isRead
                                    ? "You started video chat"
                                    : "You missed video chat",
                                colour: colorMessageClientTextWhite,
                              ),
                            //user remote side
                            if (message.sendby != uID)
                              Icon(
                                Icons.call_received,
                                color:
                                    message.isRead ? successColor : errorColor,
                              ),
                            if (message.sendby != uID)
                              CustomText(
                                content: message.isRead
                                    ? "${message.message}video chat"
                                    : "${message.message}You missed video chat",
                                colour: colorMessageClientTextWhite,
                              ),
                          ],
                        ),
                        CustomText(
                          content: DateFormat.jm()
                              .format(DateTime.parse(message.time)),
                          colour: colorMessageClientTextWhite,
                        )
                      ],
                    ),
                  )),
            ),
    );
  }
}

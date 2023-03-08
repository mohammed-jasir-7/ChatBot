import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../util.dart';
import '../../common/widgets/custom_text.dart';

class Message extends StatelessWidget {
  const Message({super.key, required this.message, required this.uID});
  final QueryDocumentSnapshot<Map<String, dynamic>> message;
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
              ? Alignment.centerRight
              : Alignment.centerLeft,
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
                      message['sendby'] == uID
                          ? const SizedBox.shrink()
                          : Icon(
                              Icons.done_all,
                              color: colorMessageClientText.withOpacity(0.5),
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

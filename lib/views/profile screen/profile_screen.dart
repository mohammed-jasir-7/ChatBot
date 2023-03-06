import 'dart:developer';

import 'package:chatbot/Models/user_model.dart';
import 'package:chatbot/util.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../common/widgets/custom_text.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key, required this.user});
  final Bot user;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backroundColor,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: colorWhite,
            )),
      ),
      backgroundColor: backroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(user.photo ?? "22"),
                ),
                sizeHeight15,
                CustomText(
                  content: user.username ?? "",
                  colour: colorWhite,
                  size: 20,
                ),
                SizedBox(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () async {
                            try {
                              final XFile? image = await _picker.pickImage(
                                  source: ImageSource.gallery);
                            } catch (e) {
                              log(e.toString());
                            }
                            // Pick an image
                          },
                          icon: Icon(
                            Icons.call_outlined,
                            color: iconColorGreen,
                            size: 30,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.video_call,
                            color: iconColorGreen,
                            size: 30,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.search,
                            color: iconColorGreen,
                            size: 30,
                          )),
                    ],
                  ),
                ),
                Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizeWidth20,
                    CustomText(
                      content: "info",
                      colour: colorWhite,
                      size: 15,
                    ),
                  ],
                ),
                sizeHeight15,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizeWidth20,
                    CustomText(
                      content: "username",
                      colour: colorWhite,
                      size: 15,
                    ),
                  ],
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: iconColorGreen,
                  ),
                  title: CustomText(
                    content: "mute Notification",
                    colour: colorWhite,
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Switch(
                      activeColor: iconColorGreen,
                      value: true,
                      onChanged: (value) {},
                    ),
                  ),
                ),
                Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizeWidth20,
                    CustomText(
                      content: "group in common",
                      colour: colorWhite,
                      size: 15,
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}

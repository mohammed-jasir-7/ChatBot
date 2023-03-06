import 'package:chatbot/util.dart';
import 'package:chatbot/views/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backroundColor,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: CircleAvatar(
                  radius: 80,
                ),
              ),
              sizeHeight15,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    content: "name",
                    colour: colorWhite,
                    size: 20,
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.edit))
                ],
              ),
              Column(
                children: List.generate(
                    4,
                    (index) =>
                        settingsList(listdata[index][0], listdata[index][1])),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<List> listdata = [
    [Icons.person, "Account"],
    [Icons.info, "About us"],
    [Icons.notifications, "Notifications"],
    [Icons.shield, "privacy"],
  ];

  ListTile settingsList(IconData icon, String field) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColorGreen,
      ),
      title: CustomText(
        content: field,
        colour: colorWhite,
      ),
    );
  }
}

import 'package:chatbot/views/new%20group%20screen/new_group_screen.dart';
import 'package:flutter/material.dart';

import '../../../Models/select_model.dart';
import '../../../util.dart';
import '../../common/widgets/custom_text.dart';

class GroupMembersIcon extends StatelessWidget {
  GroupMembersIcon({super.key, required this.bot, this.isVisible = true});
  final SelectModel bot;
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          constraints: const BoxConstraints(minWidth: 80, minHeight: 50),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: bot.bot.photo == null
                    ? const AssetImage("assets/images/nullPhoto.jpeg")
                        as ImageProvider
                    : NetworkImage(bot.bot.photo ?? ""),
              ),
              Container(
                  constraints:
                      const BoxConstraints(maxWidth: 60, maxHeight: 20),
                  child: CustomText(
                    content: bot.bot.username ?? "",
                    colour: colorWhite,
                    size: 10,
                  ))
            ],
          ),
        ),
        Visibility(
          visible: isVisible,
          child: Positioned(
              top: -18,
              left: 30,
              child: IconButton(
                  onPressed: () {
                    bot.isselected = false;
                    selectedBots.value.removeWhere(
                        (element) => element.bot.uid == bot.bot.uid);
                    selectedBots.notifyListeners();
                    if (selectedBots.value.isEmpty) {
                      isVisibleNavigation.value = false;
                      isVisibleNavigation.notifyListeners();
                    }
                  },
                  icon: const Icon(
                    Icons.close,
                    color: closeIconColor,
                    size: 15,
                  ))),
        )
      ],
    );
  }
}

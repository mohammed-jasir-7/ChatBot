import 'package:flutter/material.dart';

import '../../../Models/group_model.dart';
import '../../../util.dart';
import '../../common/widgets/custom_text.dart';

class AppBarForGroup extends StatelessWidget {
  const AppBarForGroup({super.key, required this.groupData});
  final GroupModel groupData;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: colorWhite,
          )),
      title: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              content: groupData.name,
              colour: colorWhite,
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Center(
              child: CircleAvatar(
            radius: 19,
            backgroundImage: groupData.photo == null
                ? const AssetImage(nullPhoto) as ImageProvider
                : NetworkImage(groupData.photo ?? ""),
          )),
        )
      ],
    );
  }
}

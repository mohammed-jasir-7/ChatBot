import 'package:flutter/material.dart';

import '../../common/widgets/custom_text.dart';
import '../../create_group_screen/new_group_screen.dart';

class AddMember extends StatelessWidget {
  const AddMember({super.key, required this.groupId, required this.gname});
  final String groupId;
  final String gname;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 20),
      child: Row(
        children: [
          const CustomText(content: "members"),
          const Spacer(),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewGroupScreen(
                        connections: const [],
                        isAddMemberScreen: true,
                        groupId: groupId,
                        gName: gname,
                      ),
                    ));
              },
              icon: const Icon(Icons.person_add))
        ],
      ),
    );
  }
}

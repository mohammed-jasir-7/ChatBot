import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Controllers/group functionality/group_functionality_bloc.dart';
import '../../../Controllers/message permission/msgpermission_cubit.dart';
import '../../../util.dart';
import '../../common/widgets/custom_text.dart';

class GroupSettings extends StatefulWidget {
  const GroupSettings({super.key, required this.groupId});
  final String groupId;

  @override
  State<GroupSettings> createState() => _GroupSettingsState();
}

bool isVisible = false;
bool radio = false;

class _GroupSettingsState extends State<GroupSettings> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 300,
              child: ListTile(
                onTap: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                leading: const Icon(
                  Icons.settings,
                  color: colorWhite,
                ),
                title: const CustomText(
                  content: "Group settings",
                  colour: colorWhite,
                ),
              ),
            )
          ],
        ),
        Visibility(
          visible: isVisible,
          child: BlocProvider(
            create: (context) => MsgpermissionCubit(
                firebaseAuth: FirebaseAuth.instance,
                groupId: widget.groupId,
                firestore: FirebaseFirestore.instance),
            child: BlocBuilder<MsgpermissionCubit, MsgpermissionState>(
              builder: (context, state) {
                if (state is PermissionState) {
                  log("permission state");
                  if (state.adminOnly) {
                    return ListTile(
                      onTap: () {
                        context.read<GroupFunctionalityBloc>().add(
                            AdminOnlyMessageEvent(
                                groupId: widget.groupId,
                                currentState: state.adminOnly));
                      },
                      title: const CustomText(
                        content: "only admins can message ",
                        colour: colorWhite,
                      ),
                      leading: Radio(
                        value: true,
                        groupValue: state.adminOnly,
                        activeColor: colorlogo,
                        onChanged: (value) {},
                      ),
                    );
                  } else {
                    return ListTile(
                      onTap: () {
                        context.read<GroupFunctionalityBloc>().add(
                            AdminOnlyMessageEvent(
                                groupId: widget.groupId,
                                currentState: state.adminOnly));
                      },
                      title: const Text(
                        'only admins can message ',
                      ),
                      leading: Radio(
                        value: true,
                        groupValue: state.adminOnly,
                        activeColor: colorlogo,
                        onChanged: (value) {},
                      ),
                    );
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

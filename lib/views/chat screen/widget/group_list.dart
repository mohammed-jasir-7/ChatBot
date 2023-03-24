import 'dart:developer';

import 'package:chatbot/Controllers/gchat%20bloc/gchat_bloc.dart';
import 'package:chatbot/Controllers/group%20chat%20bloc/group_bloc.dart';
import 'package:chatbot/Controllers/group%20functionality/group_functionality_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../util.dart';
import '../../common/widgets/custom_text.dart';
import '../../common/widgets/textformcommon_style.dart';
import '../../group chat screen/group_chat_screen.dart';

class GroupList extends StatelessWidget {
  GroupList({super.key});

  final _textEditingcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroupBloc>().add(FetchGroupsEvent());
    });

    return Column(
      children: [
        SizedBox(
          width: 300,
          height: 35,
          child:
//searchbar
              TextField(
            autofocus: false,
            onTap: () {},
            controller: _textEditingcontroller,
            textAlign: TextAlign.start,
            style: GoogleFonts.poppins(color: colorSearchBartext),
            decoration: searchBarStyle(hint: "      search chat or username"),
            onChanged: (value) async {},
          ),
        ),
//list view
        Expanded(
          child: BlocBuilder<GroupBloc, GroupState>(
            builder: (context, state) {
              if (state is GroupListState) {
                return ListView.separated(
                    physics: const BouncingScrollPhysics(
                        decelerationRate: ScrollDecelerationRate.fast),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return BlocListener<GroupBloc, GroupState>(
                        listener: (context, state) {
                          if (state is GroupListState) {}
                        },
                        child: InkWell(
                          onTap: () {
                            context.read<GchatBloc>().add(FetchMessageEvent(
                                groupId: state.groups[index].groupId));
                            context.read<GroupFunctionalityBloc>().add(
                                FetchMembersEvent(
                                    groupId: state.groups[index].groupId));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GroupChatScreen(
                                          groupData: state.groups[index],
                                        )));
                          },
                          child: ListTile(
                            subtitle: Container(
                              constraints: const BoxConstraints(maxWidth: 170),
                              width: 170,
                              height: 13,
                              child: CustomText(
                                content:
                                    "${state.groups[index].sendby} : ${state.groups[index].lastMsg ?? ""}",
                                colour: colorWhite,
                                size: 10,
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: colorWhite,
                              radius: 20,
                              backgroundImage: state.groups[index].photo == null
                                  ? const AssetImage(nullPhoto) as ImageProvider
                                  : NetworkImage(
                                      state.groups[index].photo ?? ""),
                            ),

                            ///connection button

                            title: CustomText(
                              content: state.groups[index].name,
                              colour: colorWhite,
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: state.groups.length);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    );
  }
}

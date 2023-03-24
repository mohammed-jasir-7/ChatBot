import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Controllers/chat bloc/chat_bloc.dart';
import '../../../Controllers/search bloc/search_bloc.dart';

import '../../../Controllers/users bloc/users_bloc.dart';
import '../../../Models/user_model.dart';
import '../../../util.dart';
import '../../common/widgets/custom_text.dart';
import '../../common/widgets/textformcommon_style.dart';
import '../../individual chat screen/individual_chat_screen.dart';

class UsersListInContact extends StatefulWidget {
  const UsersListInContact(
      {super.key, required this.users, required this.iscontactScreen});
  final List<Bot> users;
  final bool iscontactScreen;

  @override
  State<UsersListInContact> createState() => _UsersListInContactState();
}

class _UsersListInContactState extends State<UsersListInContact> {
  final _textEditingcontroller = TextEditingController();
  List<Bot> result = [];
  @override
  void initState() {
    result = widget.users;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            onChanged: (value) async {
              setState(() {
                result = widget.users
                    .where((element) => element.username!.contains(value))
                    .toList();
              });

              context.read<SearchBloc>().add(SearchingEvent(query: value));
            },
          ),
        ),
//list view
        Expanded(
          child: ListView.separated(
              physics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return BlocListener<ChatBloc, ChatState>(
                  listenWhen: (previous, current) =>
                      previous != current || previous == current,
                  listener: (context, state) {
                    if (state is ChatFirstState) {
                      log("Chat enter event");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IndividualChatScreen(
                              bot: state.bot,
                              roomID: state.roomID,
                            ),
                          ));
                    }
                  },
                  child: InkWell(
                    onTap: () {
                      if (!widget.iscontactScreen) {
                        context
                            .read<ChatBloc>()
                            .add(EnterToChatEvent(bot: result[index]));
                      }
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colorWhite,
                        radius: 20,
                        backgroundImage: NetworkImage(result[index].photo ??
                            "assets/images/nullPhoto.jpeg"),
                      ),

                      ///connection button
                      trailing: widget.iscontactScreen
                          ? requestButton(index)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                CircleAvatar(
                                  backgroundColor: Colors.green,
                                  radius: 10,
                                  child: Center(
                                      child: CustomText(
                                    content: "1",
                                    colour: colorSearchBartext,
                                    size: 10,
                                  )),
                                ),
                                CustomText(
                                  content: "5:11",
                                  colour: colorWhite,
                                )
                              ],
                            ),
                      title: CustomText(
                        content: result[index].username ?? "",
                        colour: colorWhite,
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: result.length),
        ),
      ],
    );
  }

  Widget requestButton(int index) {
    if (result[index].state == BotsState.request) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 30,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: errorColor,
              ),
              onPressed: () {
                context
                    .read<UsersBloc>()
                    .add(DeclineRequestevent(botId: result[index].uid));
                setState(() {
                  result[index].state = BotsState.connect;
                });
              },
            ),
          ),
          SizedBox(
            width: 30,
            child: IconButton(
              icon: const Icon(
                Icons.check,
                color: successColor,
              ),
              onPressed: () {
                context
                    .read<UsersBloc>()
                    .add(AcceptRequestEvent(botId: result[index].uid));
                setState(() {
                  result[index].state = BotsState.connected;
                });
              },
            ),
          ),
        ],
      );
    } else if (result[index].state == BotsState.connected) {
      return SizedBox(
        height: 25,
        child: ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(successColor)),
            onPressed: () {},
            child: const CustomText(
              content: "connected",
              colour: colorMessageClientTextWhite,
              size: 10,
            )),
      );
    } else if (result[index].state == BotsState.connect) {
      return SizedBox(
        height: 25,
        child: ElevatedButton(
            onPressed: () {
              context
                  .read<UsersBloc>()
                  .add(SendRequestEvent(botId: result[index].uid));
              setState(() {
                result[index].state = BotsState.pending;
              });
            },
            child: const CustomText(
              content: "request",
              colour: colorlogo,
              size: 10,
            )),
      );
    } else {
      return SizedBox(
        height: 25,
        child: ElevatedButton(
            onPressed: () {
              if (result[index].state == BotsState.pending) {
                context
                    .read<UsersBloc>()
                    .add(RemoveRequestEvent(botId: result[index].uid));
                setState(() {
                  result[index].state = BotsState.connect;
                });
              }
            },
            child: const CustomText(
              content: "Pending",
              size: 10,
            )),
      );
    }
  }
}

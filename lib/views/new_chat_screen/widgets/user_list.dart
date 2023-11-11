import 'dart:developer';
import 'dart:ui';
import 'package:chatbot/Controllers/videocall/videocall_bloc.dart';
import 'package:chatbot/Service/chat/chat_service.dart';
import 'package:chatbot/views/individual_chat_screen/individual_chat_screen.dart';
import 'package:chatbot/views/videocall_screen/videocall_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    log("userlistincontact");
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
        sizeHeight15,
//list view
        BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatFirstState) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context3) => IndividualChatScreen(
                      bot: state.bot,
                      roomID: state.roomID,
                    ),
                  ));
            }
          },
          child: Expanded(
            child: GridView.builder(
              itemCount: result.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.80,
                crossAxisCount: 3, // number of items in each row
                mainAxisSpacing: 8.0, // spacing between rows
                crossAxisSpacing: 8.0, // spacing between columns
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (!widget.iscontactScreen) {
                      log("enter to event");

                      context
                          .read<ChatBloc>()
                          .add(EnterToChatEvent(bot: result[index]));
                    }
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: result[index].photo == null
                                  ? const AssetImage(
                                      'assets/images/ifimagenull.jpg')
                                  : NetworkImage(result[index].photo!)
                                      as ImageProvider)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 1.0,
                            sigmaY: 1.0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.5)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor:
                                      const Color.fromARGB(255, 0, 231, 248),
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: result[index].photo == null
                                        ? const AssetImage(
                                            'assets/images/ifimagenull.jpg')
                                        : NetworkImage(result[index].photo!)
                                            as ImageProvider,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 10),
                                  child: Text(
                                    result[index].username == null ||
                                            result[index].username!.isEmpty
                                        ? 'Bot'
                                        : result[index].username!,
                                    overflow: TextOverflow.fade,
                                    style: GoogleFonts.poppins(
                                      color: colorWhite,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                widget.iscontactScreen
                                    ? requestButton(index)
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            height: 20,
                                            width: 40,
                                            child: IconButton(
                                                style: const ButtonStyle(
                                                    padding:
                                                        MaterialStatePropertyAll(
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical: 0,
                                                                    horizontal:
                                                                        8))),
                                                constraints:
                                                    const BoxConstraints(
                                                        maxHeight: 20),
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .disableNetwork();

                                                  final roomid = ChatService();
                                                  roomid.onCreateRoomId(
                                                      result[index].uid);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            VideocallScreen(
                                                                bot: result[
                                                                    index]),
                                                      ));
                                                  log("videoscreeen");
                                                  context
                                                      .read<VideocallBloc>()
                                                      .add(VideocallingEvent(
                                                          botId: result[index]
                                                              .uid));
                                                },
                                                icon: const Icon(
                                                  Icons.video_call,
                                                  color: colorlogo,
                                                )),
                                          )
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                      )),
                );
              },
            ),
          ),
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
                padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 7)),
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

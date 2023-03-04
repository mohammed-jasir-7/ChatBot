import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Controllers/chat bloc/chat_bloc.dart';
import '../../../Controllers/search bloc/search_bloc.dart';
import '../../../Models/user_model.dart';
import '../../../util.dart';
import '../../common/widgets/custom_text.dart';
import '../../common/widgets/textformcommon_style.dart';
import '../../individual chat screen/individual_chat_screen.dart';

class UsersListInContact extends StatefulWidget {
  const UsersListInContact({super.key, required this.users});
  final List<Bot> users;

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
    log("child building");
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
            decoration: searchBarStyle(),
            onChanged: (value) async {
              setState(() {
                result = widget.users
                    .where((element) => element.email.contains(value))
                    .toList();
                log(widget.users.length.toString());
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
                      context
                          .read<ChatBloc>()
                          .add(EnterToChatEvent(bot: result[index]));
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colorWhite,
                        radius: 20,
                        backgroundImage:
                            NetworkImage(result[index].photo ?? "jjjj"),
                      ),
                      trailing: Column(
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
                        content: result[index].email,
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
}

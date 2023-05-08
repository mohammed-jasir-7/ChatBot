import 'dart:developer';

import 'package:chatbot/util.dart';
import 'package:chatbot/views/common/widgets/custom_text.dart';
import 'package:chatbot/views/create_group_screen/widgets/group_member_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Controllers/group functionality/group_functionality_bloc.dart';
import '../../Models/select_model.dart';
import '../../Models/user_model.dart';
import '../common/widgets/textformcommon_style.dart';
import '../new_group_name_screen/name_screen.dart';

ValueNotifier<List<SelectModel>> selectedBots = ValueNotifier([]);
ValueNotifier<List<SelectModel>> bots = ValueNotifier([]);
ValueNotifier<bool> isVisibleNavigation = ValueNotifier(false);

class NewGroupScreen extends StatefulWidget {
  NewGroupScreen(
      {super.key,
      required this.connections,
      required this.isAddMemberScreen,
      this.groupId,
      this.gName});
  final List<Bot> connections;
  final bool isAddMemberScreen;
  String? groupId;
  String? gName;

  @override
  State<NewGroupScreen> createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  final _textEditingController = TextEditingController();
  @override
  void initState() {
    log("init state is working");
    if (widget.isAddMemberScreen) {
      if (widget.groupId != null) {
        context
            .read<GroupFunctionalityBloc>()
            .add(AddMembersEvent(groupId: widget.groupId!));
      }
    }
    selectedBots.value.clear();
    bots.value = widget.connections
        .map((e) => SelectModel(bot: e))
        .cast<SelectModel>()
        .toList();
    log(selectedBots.value.length.toString());
    searchresult = bots.value;
    super.initState();
  }

  List<SelectModel> searchresult = [];
  @override
  void dispose() {
    if (widget.isAddMemberScreen) {
      context
          .read<GroupFunctionalityBloc>()
          .add(FetchMembersEvent(groupId: widget.groupId!));
    }
    selectedBots.value.clear();
    log("disposed");
    isVisibleNavigation.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: ValueListenableBuilder(
        valueListenable: isVisibleNavigation,
        builder: (context, value, child) => Visibility(
          visible: isVisibleNavigation.value,
          child: FloatingNavigationButton(
              isAddScreen: widget.isAddMemberScreen,
              gName: widget.gName,
              groupId: widget.groupId),
        ),
      ),
      backgroundColor: backroundColor,
      appBar: AppBar(
        backgroundColor: backroundColor,
        title: BlocBuilder<GroupFunctionalityBloc, GroupFunctionalityState>(
          builder: (context, state) {
            if (!widget.isAddMemberScreen) {
              return const CustomText(
                content: "new group",
                colour: colorWhite,
              );
            } else if (state is ProvideUserListState) {
              if (!state.isLoading) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  bots.value = state.user ?? [];
                  setState(() {
                    searchresult = state.user ?? [];
                  });
                });

                bots.notifyListeners();
                const CustomText(
                  content: "Add Members",
                  colour: colorWhite,
                );
              } else {
                return const CustomText(
                  content: "Add Members",
                  colour: colorWhite,
                );
              }
            } else {
              return const CustomText(
                content: "Add Members",
                colour: colorWhite,
              );
            }
            return const CustomText(
              content: "Add Members",
              colour: colorWhite,
            );
          },
        ),
      ),
      body: Column(
        children: [
          const SelectedTiles(),
          SizedBox(
            width: 300,
            height: 30,
            child: TextField(
              autofocus: false,
              onTap: () {},
              controller: _textEditingController,
              textAlign: TextAlign.start,
              style: GoogleFonts.poppins(color: colorSearchBartext),
              decoration: searchBarStyle(hint: "search friends"),
              onChanged: (value) async {
                setState(() {
                  searchresult = bots.value
                      .where((element) => element.bot.username!.contains(value))
                      .toList();
                  log("length   ${searchresult.length}");
                });
              },
            ),
          ),
          sizeHeight15,
          Expanded(
            child: ListView.builder(
              itemCount: searchresult.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (searchresult[index].isselected) {
                      setState(() {
                        searchresult[index].isselected = false;
                      });
                      selectedBots.value.removeWhere((element) =>
                          element.bot.uid == searchresult[index].bot.uid);
                    } else {
                      selectedBots.value.add(searchresult[index]);
                      setState(() {
                        searchresult[index].isselected = true;
                      });
                    }

                    selectedBots.notifyListeners();
                    setState(() {});
                    //visiblility
                    if (selectedBots.value.length > 0) {
                      isVisibleNavigation.value = true;
                      isVisibleNavigation.notifyListeners();
                    } else {
                      isVisibleNavigation.value = false;
                      isVisibleNavigation.notifyListeners();
                    }
                  },
                  child: ValueListenableBuilder(
                    valueListenable: selectedBots,
                    builder: (context, value, child) => ListTile(
                      trailing: searchresult[index].isselected
                          ? const Icon(
                              Icons.check,
                              color: successColor,
                            )
                          : null,
                      leading: CircleAvatar(
                        backgroundColor: colorWhite,
                        radius: 20,
                        backgroundImage: searchresult[index].bot.photo == null
                            ? const AssetImage(nullPhoto) as ImageProvider
                            : NetworkImage(
                                searchresult[index].bot.photo ?? "55"),
                      ),

                      ///connection button

                      title: CustomText(
                        content: searchresult[index].bot.username ?? "",
                        colour: colorWhite,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

///floating action button
///here is function work
///
class FloatingNavigationButton extends StatelessWidget {
  FloatingNavigationButton(
      {super.key, required this.isAddScreen, this.gName, this.groupId});
  final bool isAddScreen;
  String? groupId;
  String? gName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: FloatingActionButton(
        mini: true,
        onPressed: () {
          if (isAddScreen) {
            if (gName != null && groupId != null) {
              context.read<GroupFunctionalityBloc>().add(AddMembersToDbEvent(
                  selectedBots: selectedBots.value,
                  groupId: groupId!,
                  gName: gName!));
              Navigator.pop(context);
            }
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NameScreen(seletedBots: selectedBots.value),
                ));
          }
        },
        child: isAddScreen
            ? const Icon(Icons.check)
            : const Icon(
                Icons.arrow_forward,
              ),
      ),
    );
  }
}

class SelectedTiles extends StatelessWidget {
  const SelectedTiles({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedBots,
      builder: (context, selected, child) => selected.isNotEmpty
          ? Container(
              height: 70,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) =>
                            GroupMembersIcon(bot: selected[index]),
                        itemCount: selected.length,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

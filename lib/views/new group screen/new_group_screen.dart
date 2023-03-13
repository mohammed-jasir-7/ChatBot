import 'dart:developer';

import 'package:chatbot/util.dart';
import 'package:chatbot/views/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Models/user_model.dart';
import '../common/widgets/textformcommon_style.dart';

class SelectModel {
  bool isselected = false;
  final Bot bot;

  SelectModel({required this.bot, this.isselected = false});
}

ValueNotifier<List<SelectModel>> selectedBots = ValueNotifier([]);
ValueNotifier<List<SelectModel>> Bots = ValueNotifier([]);

class NewGroupScreen extends StatefulWidget {
  NewGroupScreen({super.key, required this.connections});
  final List<Bot> connections;

  @override
  State<NewGroupScreen> createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  final _textEditingController = TextEditingController();
  @override
  void initState() {
    Bots.value = widget.connections
        .map((e) => SelectModel(bot: e))
        .cast<SelectModel>()
        .toList();
    log(selectedBots.value.length.toString());
    searchresult = Bots.value;
    super.initState();
  }

  List<SelectModel> searchresult = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backroundColor,
      appBar: AppBar(
        backgroundColor: backroundColor,
        title: const CustomText(
          content: "new group",
          colour: colorWhite,
        ),
      ),
      body: Column(
        children: [
          ValueListenableBuilder(
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
          ),
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
                  searchresult = selectedBots.value
                      .where((element) => element.bot.username!.contains(value))
                      .toList();
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
                  },
                  child: ListTile(
                    trailing: searchresult[index].isselected
                        ? Icon(Icons.check)
                        : null,
                    leading: CircleAvatar(
                      backgroundColor: colorWhite,
                      radius: 20,
                      backgroundImage: NetworkImage(
                          widget.connections[index].photo ??
                              "assets/images/nullPhoto.jpeg"),
                    ),

                    ///connection button

                    title: CustomText(
                      content: widget.connections[index].username ?? "",
                      colour: colorWhite,
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

class GroupMembersIcon extends StatelessWidget {
  const GroupMembersIcon({
    super.key,
    required this.bot,
  });
  final SelectModel bot;

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
                    ? AssetImage("assets/images/nullPhoto.jpeg")
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
        Positioned(
            top: -18,
            left: 30,
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.close,
                  color: closeIconColor,
                  size: 15,
                )))
      ],
    );
  }
}

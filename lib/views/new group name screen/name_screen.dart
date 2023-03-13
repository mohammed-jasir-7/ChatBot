import 'dart:developer';

import 'package:chatbot/Models/select_model.dart';
import 'package:chatbot/views/new%20group%20screen/widgets/group+member_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util.dart';
import '../common/widgets/custom_text.dart';
import '../common/widgets/textformcommon_style.dart';

final textController = TextEditingController();

class NameScreen extends StatelessWidget {
  NameScreen({super.key, required this.seletedBots});
  final List<SelectModel> seletedBots;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingButton(text: textController.text),
      backgroundColor: backroundColor,
      appBar: AppBar(
        backgroundColor: backroundColor,
        title: const CustomText(
          content: "new group",
          colour: colorWhite,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: textController,
                style: GoogleFonts.poppins(color: colorWhite),
                decoration: textFormFieldStyle("Enter Group Name"),
              ),
            ),
            sizeHeight15,
            CustomText(
              content: "participants",
              colour: colorWhite.withOpacity(0.5),
            ),
            sizeHeight15,
            Expanded(
              child: GridView.builder(
                itemCount: seletedBots.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100,
                    childAspectRatio: 1 / 1,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0),
                itemBuilder: (context, index) =>
                    GroupMembersIcon(bot: seletedBots[index], isVisible: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FloatingButton extends StatefulWidget {
  const FloatingButton({
    super.key,
    required this.text,
  });
  final String text;

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  Color buttoncolor = successColor;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: buttoncolor,
      onPressed: () {
        log("gggggggggggggggg ${widget.text}");
        if (textController.text.isEmpty) {
          setState(() {
            buttoncolor = errorColor;
          });
        } else {
          setState(() {
            buttoncolor = successColor;
          });
        }
      },
      child: Icon(
        Icons.check,
        color: colorMessageClientTextWhite,
      ),
    );
  }
}

import 'package:chatbot/views/common/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../util.dart';

class SettingsInfo extends StatelessWidget {
  const SettingsInfo({super.key, required this.field});
  final String field;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: backroundColor,
        child: Stack(children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              "assets/images/doodle2.png",
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: colorWhite,
                )),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/logoText.png"),
                ],
              ),
              Text(
                "Version 1.0",
                style: GoogleFonts.poppins(color: colorWhite.withOpacity(0.5)),
              ),
              if (field == "Info")
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CustomText(
                      align: TextAlign.center,
                      colour: colorWhite,
                      content:
                          "ChatBot is a secure chat application that allows it's users to stay virtually connected to their near and dear ones. The video chat feature enables users to have intimate conversations without being worried about third party interference."),
                )
            ],
          ),
        ]),
      ),
    );
  }
}

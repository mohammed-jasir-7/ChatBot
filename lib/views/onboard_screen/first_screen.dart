import 'package:chatbot/views/common/widgets/custom_text.dart';
import 'package:chatbot/views/sign_up_screen/sign_up_screen.dart';
import 'package:flutter/material.dart';

import '../../util.dart';
import 'widgets/onboard_widget_content.dart';

class OnBoardScreen extends StatelessWidget {
  const OnBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: backroundColor,
        child: SizedBox(
          child: Stack(children: [
            Image.asset(
              "assets/images/doodle2.png",
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low,
            ),
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                            (route) => false);
                      },
                      child: const CustomText(
                        content: "Skip",
                        colour: colorWhite,
                      ))
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OnBoardContentArea(),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

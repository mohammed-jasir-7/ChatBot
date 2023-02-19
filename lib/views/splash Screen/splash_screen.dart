import 'package:chatbot/views/onBoard%20Screen/first_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    authCheck(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: backroundColor,
        child: Stack(children: [
          Image.asset(
            "assets/images/doodle2.png",
            fit: BoxFit.cover,
            filterQuality: FilterQuality.low,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/Asset 1@4xxx 1.png"),
                ],
              ),
              Text(
                "Version 1.0",
                style: GoogleFonts.poppins(color: colorWhite.withOpacity(0.5)),
              )
            ],
          ),
        ]),
      ),
    );
  }
}

Future authCheck(BuildContext context) async {
  await Future.delayed(const Duration(seconds: 5));
  if (context.mounted) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const OnBoardScreen(),
    ));
  }
}

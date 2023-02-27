import 'dart:developer';
import 'package:chatbot/views/home%20Screen/home_screen.dart';
import 'package:chatbot/views/onBoard%20Screen/first_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    super.key,
  });

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

//check useer logined or not and navigating to next screeen ===================================
Future authCheck(
  BuildContext context,
) async {
  await Future.delayed(const Duration(seconds: 5));
  final user = FirebaseAuth.instance.currentUser;

  if (context.mounted) {
    if (user != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const OnBoardScreen(),
          ),
          (route) => false);
    }
  }
}

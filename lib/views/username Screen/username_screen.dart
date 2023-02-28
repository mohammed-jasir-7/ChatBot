import 'package:chatbot/views/common/widgets/custom_text.dart';
import 'package:chatbot/views/home%20Screen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util.dart';
import '../common/widgets/textformcommon_style.dart';

class UsernameScreen extends StatelessWidget {
  const UsernameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _userNameController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 100, horizontal: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/logoText.png"),
                      ],
                    ),
                  ),
                  const CustomText(
                    content: "welcome",
                    colour: colorWhite,
                    size: 25,
                  ),
                  sizeHeight15,
                  TextField(
                    obscureText: true,
                    controller: _userNameController,
                    style: GoogleFonts.poppins(color: colorWhite),
                    decoration: textFormFieldStyle("enter username"),
                  ),
                  sizeHeight15,
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_userNameController.text.isNotEmpty) {
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({"userName": _userNameController.text});
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
                                (route) => false);
                          }
                        },
                        child: const CustomText(content: "continue")),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

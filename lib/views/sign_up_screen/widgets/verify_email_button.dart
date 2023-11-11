import 'dart:async';
import 'dart:developer';
import 'package:chatbot/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Controllers/authentication/authentication_bloc.dart';
import '../../common/widgets/custom_text.dart';

class VerifyEmailButton extends StatefulWidget {
  const VerifyEmailButton(
      {super.key, required this.email, required this.password});
  final String email;
  final String password;
  @override
  State<VerifyEmailButton> createState() => _VerifyEmailButtonState();
}

class _VerifyEmailButtonState extends State<VerifyEmailButton> {
  bool isEmailVerified = false;
  Timer? timer;
  @override
  void initState() {
    timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) => checkEmailVerified(),
    );
    super.initState();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
    log("${timer?.tick.toString()}");
  }

  @override
  void dispose() {
    timer?.cancel();
    if (!FirebaseAuth.instance.currentUser!.emailVerified) {
      log("delete ");
      FirebaseAuth.instance.currentUser?.delete();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 300,
          child: ElevatedButton(
              onPressed: () {
                if (isEmailVerified) {
                  context.read<AuthenticationBloc>().add(VerifiedUserEvent());
                }
                if (timer != null && timer!.tick >= 40) {
                  BlocProvider.of<AuthenticationBloc>(context).add(SignUpEvent(
                    email: widget.email,
                    password: widget.password,
                  ));
                }
              },
              child: isEmailVerified
                  ? const CustomText(content: "Continue")
                  : const CustomText(content: "Sign up")),
        ),
        const CustomText(
          content: "check on mail box",
          colour: colorWhite,
        )
      ],
    );
  }
}

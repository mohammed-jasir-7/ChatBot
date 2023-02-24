import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Controllers/authentication/authentication_bloc.dart';
import '../../common/widgets/custom_text.dart';

class VerifyEmailButton extends StatefulWidget {
  const VerifyEmailButton({
    super.key,
  });

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
  }

  @override
  void dispose() {
    timer?.cancel();
    if (!isEmailVerified) {
      FirebaseAuth.instance.currentUser?.delete();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          if (isEmailVerified) {
            context.read<AuthenticationBloc>().add(VerifiedUserEvent());
          }
        },
        child: isEmailVerified
            ? const CustomText(content: "Continue")
            : const CustomText(content: "check on mail box"));
  }
}

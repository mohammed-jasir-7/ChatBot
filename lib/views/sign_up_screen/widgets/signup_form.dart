import 'dart:developer';
import 'package:chatbot/views/sign_up_screen/widgets/verify_email_button.dart';
import 'package:chatbot/views/username_screen/username_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../Controllers/authentication/authentication_bloc.dart';
import '../../../util.dart';
import '../../common/widgets/custom_text.dart';
import '../../common/widgets/textformcommon_style.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _signFormkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _signFormkey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is empty";
                  } else if (!EmailValidator.validate(value)) {
                    return "Enter valid email";
                  } else {
                    return null;
                  }
                },
                style: GoogleFonts.poppins(color: colorWhite),
                decoration: textFormFieldStyle("Enter Email ID"),
              ),
              sizeHeight15,
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "password is empty";
                  } else if (value.length <= 7) {
                    return "password must be at least 8 characters";
                  } else {
                    return null;
                  }
                },
                style: GoogleFonts.poppins(color: colorWhite),
                decoration: textFormFieldStyle("enter password"),
              ),
              sizeHeight15,
              BlocConsumer<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  if (state is UsernameState) {
                    log("beforee");

                    log("log hreee");
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UsernameScreen(),
                        ),
                        (route) => false);
                  } else if (state is ValidationErrorState) {
                    showTopSnackBar(
                      Overlay.of(context),
                      CustomSnackBar.success(
                        backgroundColor: Colors.red,
                        message: state.exceptionOnLogin,
                      ),
                    );
                  } else if (state is EmailVerificationState) {
                    log("jjjjjjjjjjjjjjjjjjjjjllllllllll${state.isVerified}");
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      SizedBox(
                        width: 300,
                        child: StreamBuilder<User?>(
                            stream: FirebaseAuth.instance.authStateChanges(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return const VerifyEmailButton();
                              } else {
                                return ElevatedButton(
                                    onPressed: () async {
                                      if (_signFormkey.currentState!
                                          .validate()) {
                                        BlocProvider.of<AuthenticationBloc>(
                                                context)
                                            .add(SignUpEvent(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        ));
                                      }
                                    },
                                    child:
                                        const CustomText(content: "Sign Up"));
                              }
                            }),
                      ),
                      if (state is EmailVerificationState)
                        const CustomText(
                          content: "please check mailbox....",
                          colour: colorWhite,
                        ),
                    ],
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomText(
                    size: 12,
                    content: "Already have an account?",
                    colour: colorWhite,
                  ),
                  TextButton(
                      onPressed: () {
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(LoadLoginScreenEvent());
                      },
                      child: const CustomText(
                        content: "Login",
                        colour: colorlogo,
                      ))
                ],
              )
            ],
          ),
        ));
  }
}

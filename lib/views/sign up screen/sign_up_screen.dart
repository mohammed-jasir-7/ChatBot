import 'dart:developer';

import 'package:chatbot/views/common/widgets/custom_text.dart';
import 'package:chatbot/views/home%20Screen/home_screen.dart';
import 'package:chatbot/views/sign%20up%20screen/widgets/login_form.dart';
import 'package:chatbot/views/sign%20up%20screen/widgets/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../Controllers/authentication/authentication_bloc.dart';
import '../../util.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(vertical: 50),
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
                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                      if (state is LoginState) {
                        return const CustomText(
                          content: "LOGIN",
                          colour: colorWhite,
                          weight: FontWeight.w600,
                          size: 25,
                        );
                      } else if (state is SignUpState) {
                        return const CustomText(
                          content: "SIGN UP",
                          colour: colorWhite,
                          weight: FontWeight.w600,
                          size: 25,
                        );
                      }
                      return const CustomText(
                        content: "SIGN UP",
                        colour: colorWhite,
                        weight: FontWeight.w600,
                        size: 25,
                      );
                    },
                  ),
                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                      if (state is LoginState ||
                          state is ValidationErrorState) {
                        return const LoginForm();
                      } else if (state is SignUpState) {
                        return const SignUpForm();
                      } else {
                        return const SignUpForm();
                      }
                    },
                  ),
//============google Sign up =====================================
                  BlocListener<AuthenticationBloc, AuthenticationState>(
                    // listenWhen: (previous, current) {
                    //   log("listenwhen");
                    //   return current is SignedState || previous is SignedState;
                    // },
                    listener: (context, state) {
                      log("googele navigating");
                      if (state is SignedState) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                            (route) => false);
                      } else if (state is LoadingState) {
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.success(
                            backgroundColor: Color.fromARGB(255, 54, 244, 63),
                            message: state.isLoading ? "loading" : "success",
                          ),
                        );
                      }
                    },
                    child: InkWell(
                        splashColor: Colors.amber,
                        onTap: () {
                          context
                              .read<AuthenticationBloc>()
                              .add(GoogleSignInEvent());
                        },
                        child: Image.asset("assets/images/googleLogo.png")),
                  ),
                  const CustomText(
                    size: 12,
                    content: "Sign in with Google",
                    colour: colorWhite,
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

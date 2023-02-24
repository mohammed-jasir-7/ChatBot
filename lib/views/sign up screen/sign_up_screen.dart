import 'package:chatbot/views/common/widgets/custom_text.dart';
import 'package:chatbot/views/sign%20up%20screen/widgets/login_form.dart';
import 'package:chatbot/views/sign%20up%20screen/widgets/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                  InkWell(
                      splashColor: Colors.amber,
                      onTap: () {},
                      child: Image.asset("assets/images/googleLogo.png")),
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

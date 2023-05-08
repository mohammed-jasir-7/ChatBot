import 'package:chatbot/Controllers/authentication/authentication_bloc.dart';
import 'package:chatbot/views/home/home_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../util.dart';
import '../../common/widgets/custom_text.dart';
import '../../common/widgets/textformcommon_style.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginFormkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _loginFormkey,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        context
                            .read<AuthenticationBloc>()
                            .add(LoadingForgotPasswordScreen());
                      },
                      child: CustomText(
                        content: "forgot password",
                        colour: colorWhite.withOpacity(0.7),
                      ),
                    ),
                  ),
                  sizeHeight15,
                ],
              ),
              SizedBox(
                width: 300,
//block listner
//navigate user if login success
//snack bar on exception

                child: BlocListener<AuthenticationBloc, AuthenticationState>(
                  listener: (context, state) {
                    if (state is LoggedState) {
                      if (state.isLogged) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                            (route) => false);
                      }
                    } else if (state is ValidationErrorState) {
                      showTopSnackBar(
                        Overlay.of(context),
                        CustomSnackBar.success(
                          backgroundColor: Colors.red,
                          message: state.exceptionOnLogin,
                        ),
                      );
                    }
                  },
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_loginFormkey.currentState!.validate()) {
                          BlocProvider.of<AuthenticationBloc>(context)
                              .add(LoginEvent(
                            email: _emailController.text,
                            password: _passwordController.text,
                          ));
                        }
                      },
                      child: const CustomText(content: "Login")),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomText(
                    size: 12,
                    content: "Doesn'n have an account yet?",
                    colour: colorWhite,
                  ),
                  TextButton(
                      onPressed: () {
                        BlocProvider.of<AuthenticationBloc>(context)
                            .add(LoadSignUpScreenEvent());
                      },
                      child: const CustomText(
                        content: "Sign Up",
                        colour: colorlogo,
                      ))
                ],
              )
            ],
          ),
        ));
  }
}

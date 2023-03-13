import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Controllers/authentication/authentication_bloc.dart';
import '../../../util.dart';
import '../../common/widgets/custom_text.dart';
import '../../common/widgets/textformcommon_style.dart';

ValueNotifier<int> gg = ValueNotifier(1);

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final forgotFormkey = GlobalKey<FormState>();
    return Form(
        key: forgotFormkey,
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
              SizedBox(
                width: 300,
//bloc listner
//navigate if rest password
//snack bar on exception

                child: BlocListener<AuthenticationBloc, AuthenticationState>(
                  listener: (context, state) {},
                  child: ElevatedButton(
                      onPressed: () async {
                        if (forgotFormkey.currentState!.validate()) {
                          BlocProvider.of<AuthenticationBloc>(context)
                              .add(ForgotPasswordEvent(
                            email: _emailController.text,
                          ));
                        }
                      },
                      child: const CustomText(content: "conform")),
                ),
              ),
            ],
          ),
        ));
  }
}

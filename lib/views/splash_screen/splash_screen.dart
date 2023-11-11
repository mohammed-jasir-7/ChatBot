import 'package:chatbot/Controllers/group%20chat%20bloc/group_bloc.dart';
import 'package:chatbot/Controllers/profile/profile_bloc_bloc.dart';
import 'package:chatbot/views/onboard_screen/first_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../util.dart';
import '../home/home_screen.dart';

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
        
        decoration: const BoxDecoration(
          color: backroundColor,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage( "assets/images/doodle2.png"))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/Asset 1@4xxx 1.png",filterQuality: FilterQuality.low,),
              ],
            ),
            Text(
              "Version 1.0",
              style: GoogleFonts.poppins(color: colorWhite.withOpacity(0.5)),
            )
          ],
        ),
      ),
    );
  }
}

//check useer logined or not and navigating to next screeen ===================================
Future authCheck(
  BuildContext context,
) async {
  await Future.delayed(const Duration(seconds: 3));

  final user = FirebaseAuth.instance.currentUser;

  if (context.mounted) {
    if (user != null && user.emailVerified) {
      context.read<ProfileBlocBloc>().add(LoadingProfileEvent());
      context.read<GroupBloc>().add(FetchGroupsEvent());

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
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

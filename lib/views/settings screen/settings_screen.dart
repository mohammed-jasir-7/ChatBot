import 'package:chatbot/Controllers/chat%20bloc/chat_bloc.dart';
import 'package:chatbot/Controllers/gchat%20bloc/gchat_bloc.dart';
import 'package:chatbot/Controllers/group%20chat%20bloc/group_bloc.dart';
import 'package:chatbot/Controllers/group%20functionality/group_functionality_bloc.dart';
import 'package:chatbot/util.dart';
import 'package:chatbot/views/common/widgets/custom_text.dart';
import 'package:chatbot/views/settings%20screen/widgets/profile_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../Controllers/authentication/authentication_bloc.dart';
import '../../Controllers/profile/profile_bloc_bloc.dart';
import '../splash Screen/splash_screen.dart';

final user = FirebaseAuth.instance.currentUser;

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backroundColor,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: ProfileImage(),
                ),
                sizeHeight15,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<ProfileBlocBloc, ProfileBlocState>(
                      builder: (context, state) {
                        if (state is LoadCurrentUserState) {
                          return CustomText(
                            content: state.currentUser.username ?? "",
                            colour: colorWhite,
                            size: 20,
                          );
                        }
                        return SizedBox();
                      },
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit))
                  ],
                ),
                Column(
                  children: List.generate(
                      4,
                      (index) =>
                          settingsList(listdata[index][0], listdata[index][1])),
                ),
                ElevatedButton(
                    onPressed: () async {
                      // context.read<ChatBloc>().close();
                      // context.read<GroupFunctionalityBloc>().close();
                      // context.read<GchatBloc>().close();

                      final gg = GoogleSignIn();

                      gg.disconnect();
                      FirebaseFirestore.instance.clearPersistence();
                      await FirebaseAuth.instance.signOut();

                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SplashScreen(),
                            ),
                            (route) => false);
                        // context.read<ChatBloc>().add(ChatInitialEvent());
                        // context.read<GchatBloc>().add(GchatInitialEvent());
                        // context.read<GroupBloc>().add(GroupInitialEvent());
                        // context
                        //     .read<GroupFunctionalityBloc>()
                        //     .add(GroupFunctionalityInitialEvent());
                      }
                    },
                    child: const Text("logout"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<List> listdata = [
    [Icons.person, "Account"],
    [Icons.info, "About us"],
    [Icons.notifications, "Notifications"],
    [Icons.shield, "privacy"],
  ];

  ListTile settingsList(IconData icon, String field) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColorGreen,
      ),
      title: CustomText(
        content: field,
        colour: colorWhite,
      ),
    );
  }
}

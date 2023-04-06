import 'package:chatbot/util.dart';
import 'package:chatbot/views/common/widgets/custom_text.dart';
import 'package:chatbot/views/settings%20screen/settings_info.dart';
import 'package:chatbot/views/settings%20screen/widgets/profile_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
                        return const SizedBox();
                      },
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit))
                  ],
                ),
                Column(
                  children: List.generate(
                      3,
                      (index) => settingsList(
                          listdata[index][0], listdata[index][1], context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<List> listdata = [
    [Icons.person, "Info"],
    [Icons.info, "Help"],
    [Icons.logout, "Logout"],
  ];

  ListTile settingsList(IconData icon, String field, BuildContext context) {
    return ListTile(
      onTap: () {
        switch (field) {
          case "Info":
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsInfo(field: "Info"),
                ));

            break;

          case "Help":
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsInfo(field: "Logout"),
                ));

            break;
          case "Logout":
            alert(context: context);

            break;

          default:
        }
      },
      leading: Icon(
        icon,
        color: field == "Logout" ? errorColor : iconColorGreen,
      ),
      title: CustomText(
        content: field,
        colour: colorWhite,
      ),
    );
  }
}

alert({
  required BuildContext context,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      // <-- SEE HERE
      title: Text("Logout"),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            const Text('Are you sure want to Logout?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Yes'),
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
        ),
      ],
    ),
  );
}

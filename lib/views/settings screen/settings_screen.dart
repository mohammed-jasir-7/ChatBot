import 'dart:developer';

import 'package:chatbot/Controllers/profile/profile_bloc_bloc.dart';
import 'package:chatbot/util.dart';
import 'package:chatbot/views/common/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../Models/user_model.dart';
import '../splash Screen/splash_screen.dart';

final user = FirebaseAuth.instance.currentUser;

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProfileBlocBloc>().add(LoadingProfileEvent());
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
                    const CustomText(
                      content: "name",
                      colour: colorWhite,
                      size: 20,
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
                      await FirebaseAuth.instance.signOut();

                      final gg = GoogleSignIn();
                      gg.disconnect();
                      FirebaseFirestore.instance.clearPersistence();

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SplashScreen(),
                          ),
                          (route) => false);
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

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<ProfileBlocBloc, ProfileBlocState>(
          builder: (context, state) {
            if (state is LoadCurrentUserState) {
              log("vvvvvvvvvvvvvvvvvvvvvvvvvvv settings ${(state.props.first as Bot).email}");
              return CircleAvatar(
                radius: 80,
                backgroundImage: state.currentUser.photo == null
                    ? const AssetImage("assets/images/nullPhoto.jpeg")
                        as ImageProvider
                    : NetworkImage(state.currentUser.photo ?? ""),
              );
            } else {
              return const CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage("assets/images/nullPhoto.jpeg"),
              );
            }
          },
        ),
        Positioned(
            bottom: 20,
            child: IconButton(
                onPressed: () =>
                    context.read<ProfileBlocBloc>().add(UpdateFileEvent()),
                icon: const Icon(
                  Icons.camera,
                  color: iconColorGreen,
                )))
      ],
    );
  }
}

_updateProfileImage() async {
  final result = await FilePicker.platform
      .pickFiles(type: FileType.custom, allowedExtensions: ["jpg"]);
  if (result != null) {}
}

import 'dart:developer';

import 'package:chatbot/util.dart';
import 'package:chatbot/views/call%20screen/call_screen.dart';
import 'package:chatbot/views/chat%20screen/chat_screen.dart';
import 'package:chatbot/views/new%20chat%20screen/contacts_screen.dart';
import 'package:chatbot/views/settings%20screen/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Controllers/profile/profile_bloc_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final List screens = [
    const CallScreen(),
    ChatScreen(),
    ContactScreen(),
    SettingsScreen(),
  ];
  final ValueNotifier<int> _index = ValueNotifier(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: ValueListenableBuilder(
        valueListenable: _index,
        builder: (context, index, child) => screens[index],
      ),
      bottomNavigationBar: CurvedNavigationBar(
          index: 1,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 500),
          onTap: (value) {
            _index.value = value;
          },
          buttonBackgroundColor: colorWhite,
          height: 50,
          color: const Color.fromARGB(232, 12, 121, 99),
          backgroundColor: Colors.transparent,
          items: const [
            Icon(
              Icons.call,
            ),
            ChatIcon(),
            Icon(Icons.people_alt_sharp),
            Icon(Icons.settings)
          ]),
    );
  }
}

class ChatIcon extends StatefulWidget {
  const ChatIcon({
    super.key,
  });

  @override
  State<ChatIcon> createState() => _ChatIconState();
}

class _ChatIconState extends State<ChatIcon> with WidgetsBindingObserver {
  @override
  void initState() {
    context.read<ProfileBlocBloc>().add(LoadingProfileEvent());
    WidgetsBinding.instance.addObserver(this);
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"isOnline": true});
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      log("resumed");
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"isOnline": true});
    } else if (state == AppLifecycleState.paused) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"isOnline": false});
      log("paused");
    } else if (state == AppLifecycleState.inactive) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"isOnline": false});
      log("inactive");
    } else if (state == AppLifecycleState.detached) {
      log("ditached");
    } else {
      log(state.toString());
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"isOnline": false});

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.message_outlined);
  }
}

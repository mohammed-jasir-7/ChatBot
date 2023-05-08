import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chatbot/Controllers/videocall/videocall_bloc.dart';
import 'package:chatbot/util.dart';

import 'package:chatbot/views/videocall_screen/videocall_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Controllers/profile/profile_bloc_bloc.dart';
import '../chat_screen/chat_screen.dart';
import '../new_chat_screen/contacts_screen.dart';
import '../settings_screen/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final List screens = [
    ChatScreen(),
    ContactScreen(),
    SettingsScreen(),
  ];

  final ValueNotifier<int> _index = ValueNotifier(1);
  tokenUpdate() async {
    final token = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"token": token});
  }

  @override
  void initState() {
    context.read<ProfileBlocBloc>().add(LoadingProfileEvent());
    WidgetsBinding.instance.addObserver(this);
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"isOnline": true});
    tokenUpdate();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String? title = message.notification?.title;
      String? body = message.notification?.body;
      String? channelname = message.data["channelName"];
      AwesomeNotifications().setListeners(
        onActionReceivedMethod: (receivedAction) async {
          if (channelname != null &&
              receivedAction.buttonKeyPressed == "ACCEPT") {
            context
                .read<VideocallBloc>()
                .add(CallAcceptEvent(channelname: channelname));
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideocallScreen(),
                ));
          }

          log("${receivedAction.buttonKeyPressed}  $channelname");
        },
      );
      AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 123,
            channelKey: "videocall",
            body: body,
            title: title,
            color: Colors.white,
            category: NotificationCategory.Call,
            wakeUpScreen: true,
            fullScreenIntent: true,
            autoDismissible: false,
            backgroundColor: const Color.fromARGB(255, 5, 184, 77)),
        actionButtons: [
          NotificationActionButton(
              key: "ACCEPT",
              label: "Accept call",
              color: successColor,
              autoDismissible: true),
          NotificationActionButton(
              key: "REJECT",
              label: "Reject call",
              color: successColor,
              autoDismissible: true)
        ],
      );
    });

    super.initState();
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
            Icon(Icons.message_outlined),
            Icon(Icons.people_alt_sharp),
            Icon(Icons.settings)
          ]),
    );
  }
}
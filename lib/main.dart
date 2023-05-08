import 'package:chatbot/Controllers/authentication/authentication_bloc.dart';
import 'package:chatbot/Controllers/chat%20bloc/chat_bloc.dart';
import 'package:chatbot/Controllers/group%20chat%20bloc/group_bloc.dart';
import 'package:chatbot/Controllers/profile/profile_bloc_bloc.dart';
import 'package:chatbot/Controllers/search%20bloc/search_bloc.dart';
import 'package:chatbot/Controllers/videocall/videocall_bloc.dart';
import 'package:chatbot/injectable.dart';
import 'package:chatbot/util.dart';
import 'package:chatbot/views/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Controllers/gchat bloc/gchat_bloc.dart';
import 'Controllers/group functionality/group_functionality_bloc.dart';
import 'Controllers/users bloc/users_bloc.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> backgroundhandler(RemoteMessage message) async {
  String? title = message.notification?.title;
  String? body = message.notification?.body;
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
          backgroundColor: Colors.deepOrange),
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
      ]);
}

void main() async {
  await AwesomeNotifications().initialize(
    null, //'resource://drawable/res_app_icon',//
    [
      NotificationChannel(
          channelKey: 'videocall',
          channelName: 'call',
          channelDescription: 'incomingcall',
          playSound: true,
          onlyAlertOnce: true,
          groupAlertBehavior: GroupAlertBehavior.Children,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          locked: true,
          defaultRingtoneType: DefaultRingtoneType.Ringtone,
          defaultPrivacy: NotificationPrivacy.Private,
          defaultColor: Colors.deepPurple,
          ledColor: Colors.deepPurple)
    ],
  );
  FirebaseMessaging.onBackgroundMessage(backgroundhandler);
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBloc(),
        ),
        BlocProvider(
          create: (context) => SearchBloc(),
        ),
        BlocProvider(
          create: (context) => ChatBloc(),
        ),
        BlocProvider(
          create: (context) => getIt<ProfileBlocBloc>(),
        ),
        BlocProvider(create: (context) => UsersBloc()),
        BlocProvider(create: (context) => GroupBloc()),
        BlocProvider(create: (context) => getIt<VideocallBloc>()),
        BlocProvider(lazy: true, create: (context) => getIt<GchatBloc>()),
        BlocProvider(
            lazy: true, create: (context) => getIt<GroupFunctionalityBloc>()),
      ],
      child: MaterialApp(
          builder: (_, child) => _Unfocus(child: child!),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primaryColor: primaaryColor, useMaterial3: true),
          home: const SplashScreen()),
    );
  }
}

class _Unfocus extends StatelessWidget {
  const _Unfocus({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child,
    );
  }
}

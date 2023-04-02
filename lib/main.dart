import 'package:chatbot/Controllers/authentication/authentication_bloc.dart';
import 'package:chatbot/Controllers/chat%20bloc/chat_bloc.dart';
import 'package:chatbot/Controllers/group%20chat%20bloc/group_bloc.dart';
import 'package:chatbot/Controllers/profile/profile_bloc_bloc.dart';
import 'package:chatbot/Controllers/search%20bloc/search_bloc.dart';
import 'package:chatbot/Controllers/videocall/videocall_bloc.dart';
import 'package:chatbot/Service/profile%20service/profile_service.dart';
import 'package:chatbot/injectable.dart';
import 'package:chatbot/util.dart';
import 'package:chatbot/views/splash%20Screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Controllers/gchat bloc/gchat_bloc.dart';
import 'Controllers/group functionality/group_functionality_bloc.dart';
import 'Controllers/users bloc/users_bloc.dart';

void main() async {
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

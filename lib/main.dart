import 'package:chatbot/Controllers/authentication/authentication_bloc.dart';
import 'package:chatbot/Controllers/chat%20bloc/chat_bloc.dart';
import 'package:chatbot/Controllers/profile/profile_bloc_bloc.dart';
import 'package:chatbot/Controllers/search%20bloc/search_bloc.dart';
import 'package:chatbot/Service/profile%20service/profile_service.dart';
import 'package:chatbot/util.dart';
import 'package:chatbot/views/splash%20Screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          create: (context) =>
              ProfileBlocBloc(profileService: ProfileService()),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primaryColor: primaaryColor, useMaterial3: true),
          home: const SplashScreen()),
    );
  }
}

import 'package:chatbot/util.dart';
import 'package:chatbot/views/call%20screen/call_screen.dart';
import 'package:chatbot/views/chat%20screen/chat_screen.dart';
import 'package:chatbot/views/settings%20screen/settings_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final List screens = [
    const CallScreen(),
    ChatScreen(),
    const SettingsScreen(),
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
            Icon(Icons.message_outlined),
            Icon(Icons.settings)
          ]),
    );
  }
}

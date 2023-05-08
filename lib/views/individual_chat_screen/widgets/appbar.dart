import 'package:chatbot/Controllers/user%20status/status_cubit.dart';
import 'package:chatbot/injectable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Controllers/chat bloc/chat_bloc.dart';
import '../../../Models/user_model.dart';
import '../../../util.dart';
import '../../common/widgets/custom_text.dart';
import '../../profile_screen/profile_screen.dart';

class AppBarForChat extends StatelessWidget {
  const AppBarForChat({
    super.key,
    required this.bot,
  });

  final Bot bot;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: colorWhite,
          )),
      title: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(user: bot),
              ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              content: bot.username ?? "",
              colour: colorWhite,
            ),
            BlocProvider(
              create: (context) => StatusCubit(
                  firestore: getIt.get<FirebaseFirestore>(), userId: bot.uid),
              child: BlocBuilder<StatusCubit, StatusState>(
                builder: (context, state) {
                  if (state is OnlineState) {
                    return const CustomText(
                      content: "online",
                      colour: colorWhite,
                      size: 10,
                    );
                  } else {
                    return const CustomText(
                      content: "offline",
                      colour: colorWhite,
                      size: 10,
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Center(
              child: CircleAvatar(
            radius: 19,
            backgroundImage: NetworkImage(bot.photo ?? "nnn"),
          )),
        )
      ],
    );
  }
}

import 'dart:developer';

import 'package:chatbot/Models/user_model.dart';
import 'package:chatbot/views/common/widgets/custom_text.dart';
import 'package:chatbot/views/new%20chat%20screen/widgets/user_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Controllers/users bloc/users_bloc.dart';
import '../../util.dart';

ValueNotifier<int> requestCount = ValueNotifier(0);

class ContactScreen extends StatelessWidget {
  ContactScreen({super.key});

  final List<Bot> users = [];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsersBloc>().add(const UsersListEvent());
    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
              unselectedLabelColor: colorWhite.withOpacity(0.5),
              isScrollable: true,
              splashBorderRadius: BorderRadius.circular(30),
              labelColor: colorWhite,
              dividerColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              tabs: [
                Container(child: Tab(child: CustomText(content: "All Users"))),
                Tab(
                  child: Container(
                    constraints: BoxConstraints(minWidth: 50),
                    child: Row(
                      children: [
                        CustomText(content: "Request"),
                        ValueListenableBuilder(
                          valueListenable: requestCount,
                          builder: (context, value, child) => value == 0
                              ? SizedBox.shrink()
                              : Container(
                                  margin: EdgeInsets.only(left: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: CustomText(
                                      content: value.toString(),
                                      size: 10,
                                      colour: colorMessageClientTextWhite,
                                    ),
                                  )),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
          backgroundColor: backroundColor,
          centerTitle: true,
          title: Image.asset("assets/images/logoText.png"),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: backroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            //stream builder
            //listen users collecion firestore
            child:
                BlocConsumer<UsersBloc, UsersState>(listener: (context, state) {
              log(" herrrrrrrrrrrrrrrre   ${state.toString()}");
            }, builder: (context, state) {
              final List<Bot> bots = [];
              if (state is OtherUsers) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  for (var bot in state.bots) {
                    if (bot.state == BotsState.request) {
                      bots.add(bot);
                    }
                  }
                });

                requestCount.value = bots.length;
                return TabBarView(
                  children: [
                    UsersListInContact(
                      users: state.bots,
                      iscontactScreen: true,
                    ),
                    UsersListInContact(
                      users: bots,
                      iscontactScreen: true,
                    ),
                  ],
                );
              } else {
                return TabBarView(
                    children: [Text("nodata"), Text("nodatadddddddddddddddd")]);
              }
            }),
          ),
        ),
      ),
    );
  }
}

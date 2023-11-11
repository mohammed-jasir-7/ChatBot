import 'package:chatbot/Models/group_model.dart';
import 'package:chatbot/views/group_info/widgets/group_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Controllers/group functionality/group_functionality_bloc.dart';
import '../../util.dart';
import '../common/widgets/custom_text.dart';
import '../home/home_screen.dart';
import 'functions/group_members_sheet.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class GrpupInfoScreen extends StatelessWidget {
  const GrpupInfoScreen({super.key, required this.groupInfo});
  final GroupModel groupInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backroundColor,
      appBar: AppBar(
        backgroundColor: backroundColor,
        title: const CustomText(
          content: "Group info",
          colour: colorWhite,
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: CircleAvatar(
                  backgroundImage: groupInfo.photo == null
                      ? const AssetImage(nullPhoto) as ImageProvider
                      : NetworkImage(groupInfo.photo ?? ""),
                ),
              ),
              sizeHeight15,
              CustomText(
                content: groupInfo.name,
                colour: colorWhite,
              ),
              sizeHeight15,
              //membres
              Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: ListTile(
                      onTap: () async {
                        await showMembers(
                            context, groupInfo.groupId, groupInfo.name);
                      },
                      leading: const Icon(
                        Icons.group,
                        color: colorWhite,
                      ),
                      title: const CustomText(
                        content: "members",
                        colour: colorWhite,
                      ),
                    ),
                  )
                ],
              ),
              // group settings
              BlocBuilder<GroupFunctionalityBloc, GroupFunctionalityState>(
                builder: (context, state) {
                  if (state is MembersLoadedState) {
                    if (!state.isloading) {
                      if (state.currentUser!.isAdmin) {
                        return GroupSettings(
                          groupId: groupInfo.groupId,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    } else {
                      return const SizedBox.shrink();
                    }
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              // exit group

              BlocConsumer<GroupFunctionalityBloc, GroupFunctionalityState>(
                listener: (context, state) {
                  if (state is ExitedGroup) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                        (route) => false);
                  } else if (state is DismissState) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                        (route) => false);
                  }
                },
                builder: (context, state) {
                  if (state is MembersLoadedState) {
                    if (state.currentUser != null) {
                      if (state.currentUser!.isOwner) {
                        return exitGroup(context: context, isExitGroup: false);
                      } else {
                        return exitGroup(context: context, isExitGroup: true);
                      }
                    }
                  }
                  return exitGroup(context: context, isExitGroup: true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row exitGroup({required BuildContext context, required bool isExitGroup}) {
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  // <-- SEE HERE
                  title: isExitGroup
                      ? const Text('Exit group')
                      : const Text('Dismiss group'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        isExitGroup
                            ? const Text('Are you sure want to exit group?')
                            : const Text('Are you sure want to Dismiss group?'),
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
                      onPressed: () {
                        if (isExitGroup) {
                          context
                              .read<GroupFunctionalityBloc>()
                              .add(ExitGroup(groupId: groupInfo.groupId));
                        } else {
                          context
                              .read<GroupFunctionalityBloc>()
                              .add(DismissGroup(groupId: groupInfo.groupId));
                          // Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
            leading: const Icon(
              Icons.exit_to_app,
              color: errorColor,
            ),
            title: CustomText(
              content: isExitGroup ? "exit group" : "Dismiss Group",
              colour: errorColor,
            ),
          ),
        )
      ],
    );
  }
}

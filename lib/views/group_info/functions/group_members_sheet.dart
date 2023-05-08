import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Controllers/group functionality/group_functionality_bloc.dart';
import '../../../Models/group_model.dart';
import '../../../util.dart';
import '../../common/widgets/custom_text.dart';
import '../widgets/add_member_group.dart';
import '../widgets/current_user_tile.dart';

//show mwmbers bottom sheet
Future<dynamic> showMembers(
    BuildContext context, String groupId, String gName) {
  context
      .read<GroupFunctionalityBloc>()
      .add(FetchMembersEvent(groupId: groupId));
  return showModalBottomSheet(
    backgroundColor: const Color.fromARGB(255, 0, 195, 205),
    context: context,
    builder: (context) =>
        BlocConsumer<GroupFunctionalityBloc, GroupFunctionalityState>(
      listener: (context, state) {
        if (state is MembersLoadedState) {}
      },
      builder: (context, state) {
        if (state is MembersLoadedState) {
          if (state.isloading == true) {
            return const CircularProgressIndicator();
          } else {
            return Column(
              children: [
                state.currentUser!.isAdmin
                    ? AddMember(
                        groupId: groupId,
                        gname: gName,
                      )
                    : sizeHeight15,
                CurrentUserTile(currentUser: state.currentUser!),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.members?.length,
                    itemBuilder: (context, index) => SizedBox(
                      width: 100,
                      height: 50,
                      child: Builder(builder: (contextt) {
                        return ListTile(
                          onLongPress: () async {
                            final RelativeRect position =
                                RelativeRect.fromDirectional(
                                    textDirection: TextDirection.ltr,
                                    start: 50,
                                    top: 300,
                                    end: 20,
                                    bottom: 10);
                            //  admin's actions
                            if (state.currentUser!.isAdmin) {
                              final result = await showActionMenu(
                                  contextt: contextt,
                                  currentUser: state.currentUser!,
                                  position: position,
                                  selectedUser: state.members![index]);
                              if (context.mounted) {
                                switch (result) {
                                  case "admin":
                                    context.read<GroupFunctionalityBloc>().add(
                                        MakeAdminEvent(
                                            selectedId:
                                                state.members![index].uid,
                                            groupId: groupId));
                                    break;
                                  case "removeAdmin":
                                    context.read<GroupFunctionalityBloc>().add(
                                        RemoveAsAdmin(
                                            selectedId:
                                                state.members![index].uid,
                                            groupId: groupId));

                                    break;
                                  case "remove":
                                    context.read<GroupFunctionalityBloc>().add(
                                        RemoveUserEvent(
                                            selectedId:
                                                state.members![index].uid,
                                            groupId: groupId));
                                    break;

                                  default:
                                }
                              }
                            }
                          },
                          leading: CircleAvatar(
                            backgroundImage: state.members![index].photo == null
                                ? const AssetImage(nullPhoto) as ImageProvider
                                : NetworkImage(
                                    state.members![index].photo ?? ""),
                          ),
                          title: CustomText(
                              content: state.members![index].username ?? ""),
                          trailing: state.members![index].isAdmin == true
                              ? adminTag()
                              : const SizedBox.shrink(),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            );
          }
        }
        return const CircularProgressIndicator();
      },
    ),
  );
}

//action menu
Future<String?> showActionMenu(
    {required BuildContext contextt,
    required RelativeRect position,
    required GroupMember currentUser,
    required GroupMember selectedUser}) async {
  if (!selectedUser.isOwner) {
    if (selectedUser.isAdmin && currentUser.isAdmin) {
      return showMenu(
          context: contextt, position: position, items: adminPermissionAd);
    } else if (!selectedUser.isAdmin && currentUser.isAdmin) {
      return showMenu(
          context: contextt, position: position, items: adminPermission);
    } else {
      return null;
    }
  }
  return null;
}

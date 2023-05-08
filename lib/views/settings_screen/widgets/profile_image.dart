import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../Controllers/profile/profile_bloc_bloc.dart';
import '../../../Models/user_model.dart';
import '../../../util.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocConsumer<ProfileBlocBloc, ProfileBlocState>(
          listener: (context, state) {
            if (state is UpdateErorrState) {
              showTopSnackBar(
                Overlay.of(context),
                CustomSnackBar.success(
                  backgroundColor: Colors.red,
                  message: state.messages,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is LoadCurrentUserState) {
              log("vvvvvvvvvvvvvvvvvvvvvvvvvvv settings ${(state.props.first as Profile).email}");
              return CircleAvatar(
                radius: 80,
                backgroundImage: state.currentUser.photo == null
                    ? const AssetImage("assets/images/nullPhoto.jpeg")
                        as ImageProvider
                    : NetworkImage(state.currentUser.photo ?? ""),
              );
            } else if (state is LoadingState) {
              return const CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage("assets/images/nullPhoto.jpeg"),
                child: CircularProgressIndicator(),
              );
            } else if (state is UpdateSuccessState) {
              return const CircleAvatar(
                radius: 80,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              );
            } else {
              return const CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage("assets/images/nullPhoto.jpeg"),
              );
            }
          },
        ),
        Positioned(
            bottom: 20,
            child: IconButton(
                onPressed: () =>
                    context.read<ProfileBlocBloc>().add(UpdateFileEvent()),
                icon: const Icon(
                  Icons.camera,
                  color: iconColorGreen,
                )))
      ],
    );
  }
}

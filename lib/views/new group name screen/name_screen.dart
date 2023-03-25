import 'dart:developer';
import 'dart:io';
import 'package:chatbot/Controllers/group%20chat%20bloc/group_bloc.dart';
import 'package:chatbot/Models/select_model.dart';
import 'package:chatbot/Service/profile%20service/profile_service.dart';
import 'package:chatbot/injectable.dart';
import 'package:chatbot/views/home%20Screen/home_screen.dart';
import 'package:chatbot/views/new%20group%20screen/widgets/group_member_icon.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../util.dart';
import '../common/widgets/custom_text.dart';
import '../common/widgets/textformcommon_style.dart';

final textController = TextEditingController();

class NameScreen extends StatelessWidget {
  NameScreen({super.key, required this.seletedBots});
  final List<SelectModel> seletedBots;
  final ValueNotifier<FilePickerResult?> imagePath = ValueNotifier(null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: ValueListenableBuilder(
        valueListenable: imagePath,
        builder: (context, value, child) => FloatingButton(
            text: textController.text,
            selectedBots: seletedBots,
            imagePath: imagePath.value),
      ),
      backgroundColor: backroundColor,
      appBar: AppBar(
        backgroundColor: backroundColor,
        title: const CustomText(
          content: "new group",
          colour: colorWhite,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: ValueListenableBuilder(
                    valueListenable: imagePath,
                    builder: (context, value, child) => CircleAvatar(
                      backgroundImage: imagePath.value == null ||
                              imagePath.value!.paths[0] == null
                          ? const AssetImage(nullPhoto)
                          : FileImage(File(imagePath.value!.paths[0] ?? ""))
                              as ImageProvider,
                    ),
                  ),
                ),
                Positioned.fill(
                    child: IconButton(
                        onPressed: () async {
                          imagePath.value =
                              await getIt<ProfileService>().selectImage();
                        },
                        icon: const Icon(
                          Icons.camera_enhance,
                          size: 40,
                        ))),
              ],
            ),
            sizeHeight15,
            SizedBox(
              width: 200,
              height: 40,
              child: TextField(
                controller: textController,
                style: GoogleFonts.poppins(color: colorWhite),
                decoration: textFormFieldStyle("Enter Group Name"),
              ),
            ),
            sizeHeight15,
            CustomText(
              content: "participants",
              colour: colorWhite.withOpacity(0.5),
            ),
            sizeHeight15,
            Expanded(
              child: GridView.builder(
                itemCount: seletedBots.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100,
                    childAspectRatio: 1 / 1,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0),
                itemBuilder: (context, index) =>
                    GroupMembersIcon(bot: seletedBots[index], isVisible: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FloatingButton extends StatefulWidget {
  FloatingButton(
      {super.key,
      required this.text,
      required this.selectedBots,
      this.imagePath});
  final String text;
  final List<SelectModel> selectedBots;
  FilePickerResult? imagePath;

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  Color buttoncolor = successColor;
  @override
  void dispose() {
    log("disposseddd");

    textController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: buttoncolor,
        onPressed: () {
          if (textController.text.isEmpty) {
            setState(() {
              buttoncolor = errorColor;
            });
          } else {
            context.read<GroupBloc>().add(CreateGroupEvent(
                botsId: widget.selectedBots,
                name: textController.text,
                image: widget.imagePath));
            setState(() {
              buttoncolor = successColor;
            });
          }
        },
        child: BlocConsumer<GroupBloc, GroupState>(
          listener: (context, state) {
            if (state is SuccessState) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                  (route) => false);
            }
          },
          builder: (context, state) {
            if (state is LoadingState) {
              return const CircularProgressIndicator(
                color: colorMessageClientTextWhite,
              );
            } else {
              return const Icon(
                Icons.check,
                color: colorMessageClientTextWhite,
              );
            }
          },
        ));
  }
}

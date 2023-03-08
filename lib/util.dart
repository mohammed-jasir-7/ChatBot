import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
//colors

const Color primaaryColor = Color.fromARGB(0, 76, 144, 212);
const Color backroundColor = Color.fromARGB(255, 49, 49, 49);
const Color colorWhite = Color.fromARGB(255, 255, 255, 255);
const Color colorblack = Color.fromARGB(255, 42, 42, 42);
const Color colorlogo = Color.fromARGB(255, 4, 147, 147);
const Color colorSearchBarFilled = Color.fromARGB(255, 51, 114, 99);
const Color colorSearchBartext = Color.fromARGB(255, 255, 255, 255);
const Color colorMessageCurrentuser = Color.fromARGB(255, 51, 114, 99);
const Color colorMessageClientuser = Color.fromARGB(255, 205, 235, 186);
const Color colorMessageClientText = Color.fromARGB(255, 39, 39, 39);
const Color colorMessageClientTextWhite = Color.fromARGB(255, 255, 255, 255);
const Color iconColorGreen = Color.fromARGB(255, 114, 222, 170);

//sized box gap
Widget sizeHeight15 = const SizedBox(
  height: 15,
);
Widget sizeWidth20 = const SizedBox(
  width: 20,
);
// notification
void showTopNotification(
    {required BuildContext context,
    required String state,
    required MaterialColor color}) {
  return showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.success(
      backgroundColor: color,
      message: state,
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../util.dart';

InputDecoration textFormFieldStyle(String? hint) {
  return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(color: colorWhite),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 4, 181, 187)),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      focusColor: colorWhite,
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: colorWhite),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: colorWhite),
          borderRadius: BorderRadius.all(Radius.circular(30))));
}

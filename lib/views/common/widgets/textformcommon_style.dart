import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../util.dart';

//login
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

//textfield style
//searchbar(home)
InputDecoration searchBarStyle({String? hint}) {
  return InputDecoration(
      hintText: hint,
      filled: true,
      hintStyle: GoogleFonts.poppins(
          color: colorSearchBartext.withOpacity(
        0.5,
      )),
      fillColor: colorSearchBarFilled,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.transparent)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: colorWhite)));
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {super.key,
      required this.content,
      this.colour,
      this.size,
      this.fontname,
      this.weight,
      this.align,
      this.overflow});
  final String content;
  final Color? colour;
  final double? size;
  final String? fontname;
  final FontWeight? weight;
  final TextAlign? align;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      textAlign: align,
      style: GoogleFonts.poppins(
        color: colour,
        fontSize: size,
        fontWeight: weight,
      ),
      overflow: overflow,
    );
  }
}

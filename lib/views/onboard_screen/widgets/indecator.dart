import 'package:chatbot/util.dart';
import 'package:flutter/material.dart';

List<Widget> indicator(int currentindex) => List<Widget>.generate(
    3,
    (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
          height: 10.0,
          width: 10.0,
          decoration: BoxDecoration(
              color: currentindex == index
                  ? colorWhite
                  : colorWhite.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.0)),
        ));

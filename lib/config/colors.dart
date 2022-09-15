import 'package:flutter/material.dart';

final theme = MyColors();

class MyColors {
  Color bg = const Color(0XffEDE8BC);
  Color otherBg = const Color(0Xff373A49);
  Color blue = const Color(0Xff2E8299);
  Color green = const Color(0Xff61B23F);
  Color yellow = const Color(0XffED9C32);
  Color purple = const Color(0Xff9E4F9E);
  Color red = const Color(0XffEA5050);
  Color brown = const Color(0Xff874F45);

  String settings = "light";

  MyColors() {
    setDark();
  }
  void setLight() {
    bg = const Color(0XffEDE8BC);
    otherBg = const Color(0Xff373A49);
    blue = const Color(0Xff2E8299);
    green = const Color(0Xff61B23F);
    yellow = const Color(0XffED9C32);
    purple = const Color(0Xff9E4F9E);
    red = const Color(0XffEA5050);
    brown = const Color(0Xff874F45);
    settings = "light";
  }

  void setDark() {
    bg = const Color(0Xff373A49);
    otherBg = const Color(0XffEDE8BC);
    blue = const Color(0Xff4694AE);
    green = const Color(0Xff7ACA5E);
    yellow = const Color(0XffEDBF5C);
    purple = const Color(0Xff9F659D);
    red = const Color(0XffF3706B);
    brown = const Color(0Xff935A4D);
    settings = "dark";
  }
}

Paint defaultPaint(Color color, PaintingStyle style) {
  return (Paint()
    ..color = color
    ..style = style);
}

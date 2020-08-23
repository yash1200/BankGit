import 'package:flutter/material.dart';

Color darkColor = Color(0xff4a5059);
Color orange = Color(0xfffeaf4a);
OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: BorderSide(
    color: darkColor,
    width: 1,
  ),
);
RoundedRectangleBorder roundedRectangleBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10),
  side: BorderSide(
    width: 1,
    color: darkColor,
  ),
);
RoundedRectangleBorder sheetBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(10),
    topRight: Radius.circular(10),
  ),
);
TextStyle defaultTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w400,
);
TextStyle defaultTextStyleLarge = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.w400,
);
List<LinearGradient> grads = [
  LinearGradient(
    List: [Color(0xff1d2b64), Color(0xfff8cdda)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  LinearGradient(
    List: [Color(0xff77a1d3), Color(0xffe684ae)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  LinearGradient(
    List: [Color(0xffe55d87), Color(0xff5fc3e4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  LinearGradient(
    List: [Color(0xff003873), Color(0xffe5e5be)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  LinearGradient(
    List: [Color(0xff3ca55c), Color(0xffb5ac49)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  LinearGradient(
    List: [Color(0xff1a2980), Color(0xff26d06e)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  LinearGradient(
    List: [Color(0xffaa076b), Color(0xff61045f)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  LinearGradient(
    List: [Color(0xffff512f), Color(0xffdd2476)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  LinearGradient(
    List: [Color(0xfff09819), Color(0xffedde5d)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  LinearGradient(
    List: [Color(0xff403b4a), Color(0xffe7e9bb)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  LinearGradient(
    List: [Color(0xff348f50), Color(0xff56b4d3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  LinearGradient(
    List: [Color(0xff16a085), Color(0xfff4d03f)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  LinearGradient(
    List: [Color(0xff603813), Color(0xffb29f94)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
];

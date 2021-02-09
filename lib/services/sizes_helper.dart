import 'package:flutter/material.dart';

// Note: Text Styles are also held in this file

Size displaySize(BuildContext context) {
  //debugPrint('Size = ' + MediaQuery.of(context).size.toString());
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  //debugPrint('Height = ' + displaySize(context).height.toString());
  return displaySize(context).height;
}

double displayWidth(BuildContext context) {
  //debugPrint('Width = ' + displaySize(context).width.toString());
  return displaySize(context).width;
}

bodyTextStyle(context) {
  return TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w300,
    fontSize: displayWidth(context) * 0.04,
  );
}

headingTextStyle(context) {
  return TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
  fontSize: displayWidth(context) * 0.06,
  );
}

creditsButtonTextStyle(context) {
  return TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w300,
    fontSize: displayWidth(context) * 0.06,
  );
}

textureButtonTextStyle(context) {
  return TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w300,
    fontSize: displayWidth(context) * 0.035,
  );
}


import 'package:flutter/material.dart';
// Note: Text Styles are also held in this file
ThemeData basicTheme() {
  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
        headline6: base.headline6.copyWith(
          fontFamily: 'Roboto',
          fontSize: 18.0,
          color: Colors.black,
        ),
        headline5: base.headline5.copyWith(
          fontFamily: 'Roboto',
          fontSize: 24.0,
          color: Colors.black,
        ),
        headline4: base.headline4.copyWith(
          fontFamily: 'Roboto',
          fontSize: 22.0,
          color: Colors.black,
        ),
        caption: base.caption.copyWith(
          color: Colors.black,
        ),
        bodyText2: base.bodyText2.copyWith(color: Colors.black));
  }
  final ThemeData base = ThemeData.light();
  return base.copyWith(
      appBarTheme: AppBarTheme(
        color: Colors.grey[300],
        elevation: 2.0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        textTheme: _basicTextTheme(base.textTheme),
      ),
      textTheme: _basicTextTheme(base.textTheme),
      //textTheme: Typography().white,
      primaryColor: Colors.grey[300],
      primaryTextTheme: TextTheme(),
      backgroundColor: Colors.white,
      tabBarTheme: base.tabBarTheme.copyWith(
        labelColor: Color(0xffce107c),
        unselectedLabelColor: Colors.grey,
      ));
}



















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


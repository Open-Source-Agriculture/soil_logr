import 'package:flutter/material.dart';
import 'package:soil_mate/screens/sample_list.dart';
import 'package:soil_mate/screens/side_bar/sidebar_layout.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.white
      ),
      home: SideBarLayout(),
    );
  }
}
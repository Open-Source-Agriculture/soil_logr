import 'package:flutter/material.dart';
import 'package:soil_mate/services/navigation_bloc.dart';
import 'package:soil_mate/screens/credits.dart';
import 'package:soil_mate/services/sizes_and_themes.dart';

class Home extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "HomePage",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:soil_mate/models/taxonomy_term.dart';
import 'package:soil_mate/services/navigation_bloc.dart';
import 'package:soil_mate/screens/credits.dart';
import 'package:soil_mate/services/sizes_and_themes.dart';
import 'package:soil_mate/services/taxonomy_terms.dart';

class Home extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Home",
              style: headingTextStyle(context),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 2.0,
        actions: <Widget>[],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Welcome to the Soil Mate App!\n To get started, choose one of\n our surveys',
              style: bodyTextStyle(context),
            ),
            Icon(Icons.arrow_back),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:soil_mate/models/taxonomy_term.dart';
import 'package:soil_mate/screens/side_bar/drawer.dart';
import 'package:soil_mate/screens/credits.dart';
import 'package:soil_mate/services/sizes_and_themes.dart';
import 'package:soil_mate/services/taxonomy_terms.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SizedBox(
        width: displayWidth(context)*0.66,
        child: Drawer(
           child: CustomDraw(),
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: Row(
          children: [
            // IconButton(icon: Icon(Icons.menu), onPressed: (){
            //   CustomDraw();
            // }),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text('Welcome to the ' + ' \n Soil LogR App!',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: displayWidth(context) * 0.08,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text('To get started, choose one of our surveys', style: bodyTextStyle(context),),
                    Text('by using the top left menu', style: bodyTextStyle(context),),
                    Container(
                      color: Colors.grey.withOpacity(0.3),
                        child: Icon(Icons.menu)),
                  ],
                ),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/soil_mate_logo.png'),
                  radius: displayWidth(context)*0.1,
                ),
                Column(
                  children: [
                    Text('What is Soil LogR?', style: headingTextStyle(context),),
                    Text('The Soil LogR App is a tool to aid on site ', style: bodyTextStyle(context),),
                    Text('surveys by ' +
                        'automatically capturing ', style: bodyTextStyle(context),),
                    Text('location data', style: bodyTextStyle(context),),
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
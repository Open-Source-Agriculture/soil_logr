import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soil_mate/screens/side_bar/drawer.dart';
import 'package:soil_mate/services/sizes_and_themes.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SizedBox(
        width: displayWidth(context)*0.7,
        child: Drawer(
           child: CustomDraw(),
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: Text(
          "Home",
          style: headingTextStyle(context),
        ),
        backgroundColor: Colors.white,
        elevation: 2.0,
        actions: <Widget>[],
      ),
      body: CustomScrollView(
        shrinkWrap: true,
          slivers: <Widget>[
            SliverPadding(
            padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: displayHeight(context)*0.08,),
                      Text('Welcome to the ' + ' \n Soil LogR App!',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          fontSize: displayWidth(context) * 0.08,
                        ),
                      ),
                      SizedBox(height: displayHeight(context)*0.04,),
                      Text('To get started, choose one of our surveys', style: bodyTextStyle(context),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('by using the top left menu', style: bodyTextStyle(context),),
                          RotationTransition(
                            turns: AlwaysStoppedAnimation(200 / 360),
                              child: Icon(Icons.subdirectory_arrow_right)),
                        ],
                      ),
                    ],
                  ),
                    SizedBox(height: displayHeight(context)*0.04,),
                    CircleAvatar(
                      radius: displayWidth(context)*0.15,
                      child: ClipOval(
                        child: Image.asset(
                        'assets/soil_mate_logo.png',
                        fit: BoxFit.fill,
                    ),
                      ),

                    //radius: displayWidth(context)*0.1,
                  ),
                    SizedBox(height: displayHeight(context)*0.04,),
                  Column(
                    children: [
                      Text('What is Soil LogR?', style: headingTextStyle(context),),
                      SizedBox(height: displayHeight(context)*0.02,),
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
        ],
      ),
    );
  }
}
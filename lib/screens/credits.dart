import 'package:flutter/material.dart';
import 'package:soil_mate/screens/side_bar/drawer.dart';
import '../widgets/credits_links_tile.dart';
import 'package:url_launcher/url_launcher.dart';


class Credits extends StatefulWidget{

  @override
  _CreditsState createState() => _CreditsState();
}

class _CreditsState extends State<Credits> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SizedBox(width: displayWidth(context)*0.7, child: Drawer(child: CustomDraw(),)),
      backgroundColor: Colors.white,
      appBar:  AppBar(
        title: Text(
        "Credits",
        style: headingTextStyle(context),
      ),
        backgroundColor: Colors.white,
        elevation: 2.0,
    ),
      body: CustomScrollView(
        shrinkWrap: false,
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 30),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  Text(
                    'Thank you for using Soil Mate!',
                    style: headingTextStyle(context),
                  ),
                  SizedBox(height: displayHeight(context) * 0.05,),
                  Text('To keep the development of the app free and open-source, please consider supporting us.',
                    style: bodyTextStyle(context),
                  ),
                  SizedBox(height: displayHeight(context) * 0.05,),
                  LinksTile(),
                  SizedBox(height: displayHeight(context) * 0.05,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: (displayWidth(context)*0.5),
                        child: Text(
                          'This app was developed by Open Source Agriculture. We are siblings who are passionate about agriculture and open-source.',
                          style: bodyTextStyle(context),
                        ),
                      ),
                      Container(
                        width: (displayWidth(context)*0.3),
                        height: (displayWidth(context)*0.3),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        child: Image(
                            image: AssetImage('assets/credits_selfie.jpg'),
                            fit: BoxFit.fill
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}



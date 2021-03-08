import 'package:flutter/material.dart';
import '../widgets/credits_links_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:soil_mate/services/navigation_bloc.dart';


class Credits extends StatefulWidget with NavigationStates{

  @override
  _CreditsState createState() => _CreditsState();
}

class _CreditsState extends State<Credits> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Credits",
            style: headingTextStyle(context),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 2.0,
      actions: <Widget>[],
    ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Expanded(
          child: Container(
            height: displayHeight(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                    'Thank you for using Soil Mate!',
                  style: headingTextStyle(context),
                ),
                Text('To keep the development of the app free and open-source, please consider supporting us.',
                style: bodyTextStyle(context),
                ),
                LinksTile(),
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
      ),
    );
  }
}



import 'package:flutter/material.dart';
import '../../widgets/credits_links_tile.dart';
import 'package:url_launcher/url_launcher.dart';


class Credits extends StatefulWidget {

  @override
  _CreditsState createState() => _CreditsState();
}

class _CreditsState extends State<Credits> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Credits",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.grey[300],
        elevation: 2.0,
        actions: <Widget>[

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
                'Thank you for using Soil Mate!',
              style: buttonTextStyle(),
            ),
            Text('To keep the development of the app free and open-source, please consider supporting us.',
            style: bodyTextStyle(),
            ),
            LinksTile(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 250,
                  child: Text(
                    'This app was developed by Open Source Agriculture. We are siblings who are passionate about agriculture and open-source.',
                    style: bodyTextStyle(),
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
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
    );
  }
}


buttonTextStyle() {
  return TextStyle(
  fontFamily: 'Dosis',
  fontWeight: FontWeight.w900,
  fontSize: 20,
  );
}

bodyTextStyle() {
  return TextStyle(
    fontFamily: 'Dosis',
    fontWeight: FontWeight.w900,
    fontSize: 16,
  );
}


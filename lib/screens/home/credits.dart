import 'package:flutter/material.dart';
//import '../../widgets/credits_button.dart';
import 'package:url_launcher/url_launcher.dart';


class Credits extends StatefulWidget {

  @override
  _CreditsState createState() => _CreditsState();
}

class _CreditsState extends State<Credits> {

  int index;

  List<LinkList> links = [
    LinkList(url: 'https://discord.gg/8x58DuxfGz', label: 'Join our community on Discord', image: 'discord_logo.jpg'),
    LinkList(url: 'https://www.patreon.com/opensourceagriculture', label: 'Support our Patreon', image: 'patreon_logo.png'),
    LinkList(url: 'https://github.com/Open-Source-Agriculture', label: 'Check us out on GitHub', image: 'github_logo.png'),
    LinkList(url: 'https://open-source-agriculture.github.io', label: 'Explore our website', image: 'website_logo.png'),
  ];

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
            Container(
              height: 300,
              child: ListView.builder(
                itemCount: links.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black, width: 1.0),
                        ),
                        child: ListTile(
                          onTap: () async {
                            if (await canLaunch(links[index].url)) {
                              await launch(links[index].url);
                            } else {
                              throw 'Could not launch ${links[index].url}';
                            }
                          },
                          title: Text(links[index].label,
                            style: buttonTextStyle(),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: AssetImage('assets/${links[index].image}'),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
              ),
            ),
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

class LinkList{

  String image;
  String url;
  String label;

  LinkList({ this.image, this.url, this.label });

}

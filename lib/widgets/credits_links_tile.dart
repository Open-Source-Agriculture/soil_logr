import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/sizes_and_themes.dart';
export '../services/sizes_and_themes.dart';

class LinksTile extends StatefulWidget {

  @override
  _LinksTileState createState() => _LinksTileState();
}

class _LinksTileState extends State<LinksTile> {
  int index;

  List<LinkList> links = [
    LinkList(url: 'https://discord.gg/8x58DuxfGz', label: 'Join us on Discord', image: 'discord_logo.jpg'),
    LinkList(url: 'https://www.patreon.com/opensourceagriculture', label: 'Support our Patreon', image: 'patreon_logo.png'),
    LinkList(url: 'https://github.com/Open-Source-Agriculture', label: 'Check us out on GitHub', image: 'github_logo.png'),
    LinkList(url: 'https://open-source-agriculture.github.io', label: 'Explore our website', image: 'website_logo.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
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
                  style: creditsButtonTextStyle(context),
                ),
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/${links[index].image}'),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          );
        }
    );
  }
}


class LinkList{

  String image;
  String url;
  String label;

  LinkList({ this.image, this.url, this.label });

}

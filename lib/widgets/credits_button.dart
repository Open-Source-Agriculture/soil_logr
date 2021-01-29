import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/credits_link_list.dart';
export '../services/credits_link_list.dart';

class CreditsButton extends StatelessWidget {
  String image;
  String url;
  String label;

  CreditsButton({
    Key /*?*/ key,
    @required this.image,
    @required this.url,
    @required this.label,
  }) : super(key: key) {}


  List<LinkList> links = [
    LinkList(url: 'https://discord.gg/8x58DuxfGz', label: 'Join our community on Discord', image: 'discord_logo.jpg'),
    LinkList(url: 'https://www.patreon.com/opensourceagriculture', label: 'Support our Patreon', image: 'patreon_logo.png'),
    LinkList(url: 'https://github.com/Open-Source-Agriculture', label: 'Check us out on GitHub', image: 'github_logo.png'),
    LinkList(url: 'https://open-source-agriculture.github.io', label: 'Explore our website', image: 'website_logo.png'),
  ];





  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.grey)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: buttonTextStyle(),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.fill
              ),
            ),
          ),
        ],
      ),
      onPressed: () async {
        if (await canLaunch(url)) {
        await launch(url);
        } else {
        throw 'Could not launch $url';
        }
      },
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
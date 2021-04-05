import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soil_mate/services/sizes_and_themes.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDraw extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate(<Widget>[
                SizedBox(height: kToolbarHeight,),
                Text('  Select A Survey:',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    fontSize: displayWidth(context) * 0.07,
                  ),
                ),
                Divider(
                  height: 64,
                  thickness: 1,
                  color: Colors.grey.withOpacity(0.6),
                  indent: 32,
                  endIndent: 32,
                ),
                ListTile(
                  title: Text('Texture Survey', style: heading2TextStyle(context),),
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/soil.jpeg'),
                    radius: displayWidth(context)*0.07,
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/texture_survey');
                  },
                ),
                Divider(
                  height: 64,
                  thickness: 1,
                  color: Colors.grey.withOpacity(0.6),
                  indent: 32,
                  endIndent: 32,
                ),
                ListTile(
                  title: Text('Ground Cover Survey', style: heading2TextStyle(context)),
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/grass.jpeg'),
                    radius: displayWidth(context)*0.07,
                  ),
                  onTap: () {
                    //onIconPressed();
                    //Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/ground_cover_survey');
                    //BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.GroundCoverSurveyClickedEvent);
                  },
                ),
                Divider(
                  height: 64,
                  thickness: 1,
                  color: Colors.grey.withOpacity(0.6),
                  indent: 32,
                  endIndent: 32,
                ),
              ListTile(
                title: Text('Request New Survey', style: heading2TextStyle(context)),
                leading: Container(
                    height: displayWidth(context)*0.14,
                    width: displayWidth(context)*0.14,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.lightBlueAccent, width: 1),
                    ),
                    child: Icon(Icons.format_align_center_sharp)),
                onTap: () async {
                  if (await canLaunch("https://docs.google.com/forms/d/e/1FAIpQLSdsIMoc4GhQQOpGeLxAaQaFQ6IJ7Eodqqd58tGHHJWSOupFvg/viewform")) {
                    await launch("https://docs.google.com/forms/d/e/1FAIpQLSdsIMoc4GhQQOpGeLxAaQaFQ6IJ7Eodqqd58tGHHJWSOupFvg/viewform");
                  } else {
                    throw 'Could not launch ${"https://docs.google.com/forms/d/e/1FAIpQLSdsIMoc4GhQQOpGeLxAaQaFQ6IJ7Eodqqd58tGHHJWSOupFvg/viewform"}';
                  }
                },
              ),
              Divider(
                height: 64,
                thickness: 0.5,
                color: Colors.grey.withOpacity(0.3),
                indent: 32,
                endIndent: 32,
              ),
                ListTile(
                  title: Text('Credits', style: heading2TextStyle(context)),
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/website_logo.png'),
                    backgroundColor: Colors.white,
                    radius: displayWidth(context)*0.07,
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/credits');
                  },
                ),
                Divider(
                  height: 64,
                  thickness: 0.5,
                  color: Colors.grey.withOpacity(0.3),
                  indent: 32,
                  endIndent: 32,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

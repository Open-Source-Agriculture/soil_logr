import 'package:flutter/material.dart';
import 'package:soil_mate/services/sizes_and_themes.dart';

class CustomDraw extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color:  Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(height: 2*kToolbarHeight,),
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
            title: Text('Texture Survey', style: headingTextStyle(context),),
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
            title: Text('Ground Cover Survey', style: headingTextStyle(context)),
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
            title: Text('Credits', style: headingTextStyle(context)),
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
    );
  }
}

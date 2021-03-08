import 'package:flutter/material.dart';
import 'package:soil_mate/models/log.dart';
import 'package:soil_mate/models/texture_models.dart';

Color getColor(int sand, int silt, int clay) {
  int R = (225*sand + 225*clay)~/100;
  int G = (225*sand + 225*silt)~/100;
  int B = (225*silt + 225*clay)~/100;
  return Color.fromRGBO(R, G, B, 1);
}

class SampleListTile extends StatelessWidget {
  final Log textureLog;
  double sand = 30.0;
  double silt = 10.0;
  double clay = 60.0;

  double depthShallow = 0.0;
  double depthDeep = 0.0;



  SampleListTile({
    Key /*?*/ key,
  @required this.textureLog,
  }) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: getColor(sand.toInt(), silt.toInt(), clay.toInt()), width: 3.0),
          color: getColor(sand.toInt(), silt.toInt(), clay.toInt()).withOpacity(0.7),
        ),
        child: ListTile(
          onTap: () {
            print("Nothing");
          },
          // title: Text(locations[index].location),
          title: Text('ID: '+ textureLog.id.toString()
              + '    Texture: ' + textureLog.name
              + '\n' + textureLog.geofield.lat.toString() + ', '
              + textureLog.geofield.lon.toString()
              ),
          subtitle: Text('Sand: ' + sand.toString()
              + ', Silt: ' + silt.toString()
              + ', Clay: ' +  clay.toString()
              + '\nDepth Upper: ' +  depthShallow.toString()
              + ', Depth Lower: '  + depthDeep.toString()
          ),
          /*leading: Text('1') CircleAvatar(
                      backgroundImage: AssetImage('assets/${locations[index].flag}'),
                    ),*/
        ),
      ),
    );
  }
}
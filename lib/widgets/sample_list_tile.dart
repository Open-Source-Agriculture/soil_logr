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
//          border: Border.all(color: getColor(reverseBaseSamples[index].sand, reverseBaseSamples[index].silt, reverseBaseSamples[index].clay), width: 3.0),
//          color: getColor(reverseBaseSamples[index].sand, reverseBaseSamples[index].silt, reverseBaseSamples[index].clay).withOpacity(0.7),
        ),
        child: ListTile(
          onTap: () {
            print("Nothing");
          },
          // title: Text(locations[index].location),
          title: Text('ID: '+ textureLog.id.toString()
              + '    Texture: ' + textureLog.name
//              + '\n' + textureLog.geofield.lat.toString() + ', '
//              + textureLog.geofield.lat.toString()
              ),
//          subtitle: Text('Sand: ' + reverseBaseSamples[index].sand.toString()
//              + ', Silt: ' + reverseBaseSamples[index].silt.toString()
//              + ', Clay: ' +  reverseBaseSamples[index].clay.toString()
//              + '\nDepth Upper: ' +  reverseBaseSamples[index].depthShallow.toString()
//              + ', Depth Lower: '  + reverseBaseSamples[index].depthDeep.toString()
//          ),
          /*leading: Text('1') CircleAvatar(
                      backgroundImage: AssetImage('assets/${locations[index].flag}'),
                    ),*/
        ),
      ),
    );
  }
}
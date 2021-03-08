import 'package:flutter/material.dart';
import 'package:soil_mate/models/log.dart';

class SampleListTile extends StatelessWidget {
  final Log textureLog;
  final Color color;
  final List<String> excludeList;




  SampleListTile({
    Key /*?*/ key,
    @required this.textureLog,
    @required this.color,
    @required this.excludeList,
  }) : super(key: key) {}

  @override
  Widget build(BuildContext context) {


    String quantityString = "";
    textureLog.quantity.forEach((q) {
      if (!excludeList.contains(q.label)){
        quantityString = quantityString + "${q.label}: ${q.value}\n";
      }
      

    });


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color, width: 3.0),
          color: color.withOpacity(0.7),
        ),
        child: ListTile(
          onTap: () {
            print("Nothing");
          },
          // title: Text(locations[index].location),
          title: Text('ID: '+ textureLog.id.toString()
               + '    ' +textureLog.name
              + '\n' + textureLog.geofield.lat.toString() + ', '
              + textureLog.geofield.lon.toString()
              ),
          subtitle: Text(quantityString),
          /*leading: Text('1') CircleAvatar(
                      backgroundImage: AssetImage('assets/${locations[index].flag}'),
                    ),*/
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:soil_mate/models/log.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
      padding: const EdgeInsets.only(top: 1.0),
      child: Container(
        decoration: BoxDecoration(
          //borderRadius: BorderRadius.circular(15),
          //border: Border.all(color: color, width: 3.0),
          color: color.withOpacity(0.5),
        ),
        child: Slidable(
          actionPane: SlidableScrollActionPane(),
          actions: [
            IconSlideAction(
              caption: 'Cancel',
              color: Colors.grey[300],
              icon: Icons.cancel_outlined,
              onTap: (){},
            ),
          ],
          child: ListTile(
            title: Text('ID: '+ textureLog.id.toString()
                 + '    ' +textureLog.name
                + '\n' + textureLog.geofield.lat.toString() + ', '
                + textureLog.geofield.lon.toString()
                ),
            subtitle: Text(quantityString),
          ),
        ),
      ),
    );
  }
}
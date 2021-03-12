import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:soil_mate/models/log.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SampleListTile extends StatelessWidget {
  final Log sampleLog;
  final Color color;
  final List<String> excludeList;

  final String boxname;

  SampleListTile({
    Key /*?*/ key,
    @required this.sampleLog,
    @required this.color,
    @required this.excludeList,
    @required this.boxname,
  }) : super(key: key) {}

  @override
  Widget build(BuildContext context) {


    String quantityString = "";
    sampleLog.quantity.forEach((q) {
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
          actionExtentRatio: 1/2,
          actions: [
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                Box box = Hive.box(boxname);
                print(box.keys);
                box.delete(sampleLog.id);
                print(box.keys);
              },
            ),
            IconSlideAction(
              caption: 'Cancel',
              color: Colors.grey[300],
              icon: Icons.cancel_outlined,
              onTap: (){},
            ),
          ],
          child: ListTile(
            title: Text('ID: '+ sampleLog.id.toString()
                 + '    ' +sampleLog.name
                + '\n' + sampleLog.geofield.lat.toString() + ', '
                + sampleLog.geofield.lon.toString()
                ),
            subtitle: Text(quantityString),
          ),
        ),
      ),
    );
  }
}
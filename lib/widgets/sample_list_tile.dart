import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:soil_mate/models/log.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:soil_mate/widgets/credits_links_tile.dart';


const String PLACEHOLDER_IMG = "assets/placeholder.png";

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



    File imgFile = File(sampleLog.images[0]);




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
                if (imgFile.path != PLACEHOLDER_IMG){
                  imgFile.delete();
                }
                Box box = Hive.box(boxname);
                box.delete(sampleLog.id);
              },
            ),
            IconSlideAction(
              caption: 'Cancel',
              color: Colors.grey[300],
              icon: Icons.cancel_outlined,
              onTap: (){},
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.fromLTRB(17,12, 12,8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'ID: '+ sampleLog.id.toString()
                              + ',    ' +sampleLog.name + '\n'
                              + sampleLog.geofield.lat.toString() + ', '
                              + sampleLog.geofield.lon.toString(),
                        style: headingTextStyle(context),
                      ),
                      Text(quantityString, style: bodyTextStyle(context),),                  ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CircleAvatar(
                    radius: displayWidth(context)*0.1,
                    backgroundImage: (sampleLog.images == null) ? AssetImage(PLACEHOLDER_IMG) : (sampleLog.images.length < 1) ? AssetImage(PLACEHOLDER_IMG) : FileImage(File(sampleLog.images[0])),
                  ),
                ),
              ],

            ),
          ),
        ),
      ),
    );
  }
}
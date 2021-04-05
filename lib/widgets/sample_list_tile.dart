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
            padding: const EdgeInsets.fromLTRB(0,5,0,0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: CircleAvatar(
                    radius: displayWidth(context)*0.07,
                    backgroundImage: (sampleLog.images == null) ? AssetImage(PLACEHOLDER_IMG) : (sampleLog.images.length < 1) ? AssetImage(PLACEHOLDER_IMG) : FileImage(File(sampleLog.images[0])),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8,0,8,0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                'ID: '+ sampleLog.id.toString(),
                              style: heading2TextStyle(context),
                            ),
                            Text(
                              sampleLog.name,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                fontSize: displayWidth(context) * 0.045,
                              ),
                            ),
                          ],
                        ),
                        Text(quantityString, style: bodyTextStyle(context),),                  ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        sampleLog.geofield.lat.toString() ,
                        style: body2TextStyle(context),
                      ),
                      Text(
                        sampleLog.geofield.lon.toString() + '\n' +'\n' + '\n',
                        style: body2TextStyle(context),
                      ),
                    ],
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
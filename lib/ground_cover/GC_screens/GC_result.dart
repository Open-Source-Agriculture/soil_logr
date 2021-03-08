import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:soil_mate/ground_cover/GC_models/GC_model.dart';
import 'package:soil_mate/ground_cover/GC_screens/GC_form.dart';
import 'package:soil_mate/models/log.dart';
import 'dart:io';

import 'package:soil_mate/services/navigation_bloc.dart';

class GroundCoverResult extends StatefulWidget   with NavigationStates{
  GroundCoverModel model;

  GroundCoverResult({this.model});

  @override
  _GroundCoverResultState createState() => _GroundCoverResultState();
}

class _GroundCoverResultState extends State<GroundCoverResult> {
  List<GroundCoverModel> GroundCoverList = [];

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(title: Text('Ground Cover Result')),
      body: Column(
        children: [
          Expanded(child: GroundCoverTile()),
          // ListView.builder(
          //
          //   itemCount: 1, //GroundCoverList.length,
          //   itemBuilder: (context, index){
          //   return Card(
          //     child: ListTile(
          //       // leading: CircleAvatar(
          //       //   radius: 80,
          //       //   backgroundImage: widget.model.imageFile == null ? AssetImage("assets/placeholder.png"): FileImage(File(widget.model.imageFile.path)),
          //       // ),
          //         title: Text('Species: ' + widget.model.totalSpeciesCount.toString()),
          //       subtitle: Text(
          //           'Cover %: ${widget.model.coverPercentage} ' +
          //               'Cover Height: ${widget.model.coverHeight}' +
          //               'Weeds Ratio: ${widget.model.weedsRatio}' +
          //           '\n Lat: ${widget.model.lat} Lon: ${widget.model.lon}'
          //       ),
          //     ),
          //   );
          //   }
          // ),
        ],
      ),
      bottomNavigationBar: Row(
        children: [
          ElevatedButton(
            child: Text('test'),
            onPressed: () {
              final groundCoverLog = Hive.box("gc_log");
              List tKeys = groundCoverLog.keys.toList();
              print("------------------------");
              tKeys.forEach((element) {
                final Log gcLog = groundCoverLog.get(element) as Log;
                print(gcLog.name);
              });

            }
          ),
          ElevatedButton(
            child: Text('Add Sample'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroundCoverForm()));
              }
          ),
        ],
      ),
    );
  }
  Widget _buildListView() {
    return FutureBuilder(
        future: Hive.openBox("gc_log"),
        builder: (context, snapshot) {
          return ValueListenableBuilder(
            valueListenable: Hive.box("gc_log").listenable(),
            builder: (context, groundCoverLog, _) {
              return ListView.builder(
                itemCount: groundCoverLog.length,
                itemBuilder: (BuildContext context, int index) {
                  final gcLog = groundCoverLog.getAt(index) as Log;

                  return ListTile(
                    title: Text(gcLog.name),
                    subtitle: Text(gcLog.id.toString()),
                  );
                },
              );
            },
          );
        }
    );
  }
}

class GroundCoverTile extends StatefulWidget{
  @override
  _GroundCoverTileState createState() => _GroundCoverTileState();
}

class _GroundCoverTileState extends State<GroundCoverTile> {




  @override
  Widget build(BuildContext context) {



    return FutureBuilder(
        future: Hive.openBox('gc_logs'),
        builder: (BuildContext context, AsyncSnapshot snapshot){


          if (snapshot.connectionState == ConnectionState.done){
            final Box groundCoverLogBox = Hive.box("gc_logs");
            List gcKeys = groundCoverLogBox.keys.toList();
            if (snapshot.hasError){
              return Column(
                children: [
                  Container(
                    height: 200,
                    width: 100,
                    color: Colors.lightGreenAccent,
                  ),
                  Text(snapshot.error.toString()),
                ],
              );
            }else{
              return ValueListenableBuilder(
                  valueListenable: groundCoverLogBox.listenable(),
                  builder: (context, box, widget){
                    return ListView.builder(
                      itemCount: gcKeys.length,
                      itemBuilder: (BuildContext context, int index) {
                        final gcLog = groundCoverLogBox.getAt(index) as Log;

                        return ListTile(
                          title: Text(gcLog.name),
                          subtitle: Text(gcLog.id.toString()),
                        );
                      },
                    )
                    ;
                  }

              );
            }
          }else{
            return Scaffold();
          }
        }
    );
  }
}

















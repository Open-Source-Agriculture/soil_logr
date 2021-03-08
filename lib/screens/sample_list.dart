import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soil_mate/services/location_service.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:soil_mate/models/log.dart';
import 'package:soil_mate/models/taxonomy_term.dart';
import 'package:soil_mate/models/texture_models.dart';
import 'package:soil_mate/services/navigation_bloc.dart';
import 'package:soil_mate/services/send_email.dart';
import 'package:soil_mate/services/sizes_and_themes.dart';
import 'package:soil_mate/widgets/sample_list_tile.dart';
import 'package:soil_mate/widgets/sample_summary_container.dart';
import 'dart:async';
import 'credits.dart';

class SampleList extends StatefulWidget with NavigationStates {
  @override
  _SampleListState createState() => _SampleListState();
}

class _SampleListState extends State<SampleList> {

  bool dataLoaded = false;
  String baseSiteKey = "BaseSite";
  TextureClass selectedTexture = AusClassification().getTextureList()[0];
  int depthUpper = 0;
  int depthLower = 10;
  int increment = 0;

  @override
  Widget build(BuildContext context) {



    Future addTextureLog() async {
      final taxonomyTermBox = Hive.box("taxonomy_term");
      TaxonomyTerm taxonomyTerm = taxonomyTermBox.get(selectedTexture.key);
      Box box = Hive.box("texture_logs");
      int newID = box.length;
      Position pos = await determinePosition();
      GeoField geoField = GeoField(lat: pos.latitude, lon: pos.longitude);

      TaxonomyTerm percentUnit = TaxonomyTerm(tid: 15, name: "%", description: "percentage", parent: [], parents_all: []);
      TaxonomyTerm cmUnit = TaxonomyTerm(tid: 18, name: "cm", description: "Center meters", parent: [], parents_all: []);

      List<Quantity> selectedQuanties = [
        Quantity(measure: "value", value: selectedTexture.sand.toDouble(), units: percentUnit, label: "sand"),
        Quantity(measure: "value", value: selectedTexture.silt.toDouble(), units: percentUnit, label: "silt"),
        Quantity(measure: "value", value: selectedTexture.clay.toDouble(), units: percentUnit, label: "clay"),
        Quantity(measure: "value", value: depthUpper.toDouble(), units: cmUnit, label: "depthUpper"),
        Quantity(measure: "value", value: depthLower.toDouble(), units: cmUnit, label: "depthLower"),
      ];


      Log newTextureLog = Log(
          id: newID,
          name: selectedTexture.name,
          type: "texture_observation",
          timestamp: DateTime.now().toString(),
          notes: "",
          geofield: geoField,
          log_category: [taxonomyTerm],
          quantity: selectedQuanties);
      box.put(newID, newTextureLog);
    }

    void _showAddSamplePanel() {
      var txt2 = TextEditingController();
      txt2.text = depthUpper.toString();
      txt2.selection = TextSelection.fromPosition(
          TextPosition(offset: depthUpper.toString().length));

      var txt3 = TextEditingController();
      txt3.text = depthLower.toString();
      txt3.selection = TextSelection.fromPosition(
          TextPosition(offset: depthLower.toString().length));

      var txt4 = TextEditingController();
      txt4.text = increment.toString();
      txt4.selection = TextSelection.fromPosition(
          TextPosition(offset: increment.toString().length));


      showModalBottomSheet<dynamic>(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState
                    /*You can rename this!*/) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  runSpacing: 17,
                  children: <Widget>[
                    GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      childAspectRatio: (3 / 1),
                      crossAxisCount: 3,
                      children: AusClassification()
                          .getTextureList()
                          .map((texture) => Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  color: texture.getColor().withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: texture.getColor(),
                                          width: 2,
                                          style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(15)),
                                  onPressed: () {
                                    setState(() {
                                      selectedTexture = texture;
                                      print("setting state");
                                      print(texture.name);
                                    });
                                  },
                                  child: Text(
                                    texture.name,
                                    style: textureButtonTextStyle(context),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Upper depth: ',
                                  style: bodyTextStyle(context),
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints.tight(Size(
                                      (0.06 * displayHeight(context)),
                                      (0.035 * displayHeight(context)))),
                                  child: TextFormField(
                                    style: bodyTextStyle(context),
                                    maxLength: 3,
                                    decoration: InputDecoration(
                                      counterText: '',
                                      border: InputBorder.none,
                                      filled: true,
                                    ),
                                    controller: txt2,
                                    autovalidateMode: AutovalidateMode.always,
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) {
                                      setState(() {
                                        depthUpper = int.parse(val);
                                        print(depthUpper);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Lower depth: ',
                                  style: bodyTextStyle(context),
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints.tight(Size(
                                      (0.06 * displayHeight(context)),
                                      (0.035 * displayHeight(context)))),
                                  child: TextFormField(
                                    style: bodyTextStyle(context),
                                    maxLength: 3,
                                    decoration: InputDecoration(
                                      counterText: '',
                                      border: InputBorder.none,
                                      filled: true,
                                    ),
                                    controller: txt3,
                                    autovalidateMode: AutovalidateMode.always,
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) {
                                      setState(() {
                                        depthLower = int.parse(val);
                                        print(depthLower);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'ID: ',
                                  style: bodyTextStyle(context),
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints.tight(Size(
                                      (0.1 * displayHeight(context)),
                                      (0.035 * displayHeight(context)))),
                                  child: TextFormField(
                                    style: bodyTextStyle(context),
                                    maxLength: 5,
                                    decoration: InputDecoration(
                                      counterText: '',
                                      border: InputBorder.none,
                                      filled: true,
                                    ),
                                    controller: txt4,
                                    autovalidateMode: AutovalidateMode.always,
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) {
                                      setState(() {
                                        increment = int.parse(val);
                                        print(increment);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SampleSummary(
                          selectedTexture: this.selectedTexture,
                          depthUpper: depthUpper,
                          depthLower: depthLower,
                          sampleID: increment,
                        )
                      ],
                    ),
                    Center(
                        child: RaisedButton(
                            child: Text("Save"),
                            onPressed: () {
                              addTextureLog();
                              Navigator.pop(context);
                            })),
                  ],
                ),
              );
            });
          });
    }

    createAlertDialog(BuildContext context) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Delete all samples'),
              content: Text('Are you sure you want to delete?'),
              actions: [
                MaterialButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(SampleList());
                  },
                ),
                MaterialButton(
                  child: Text('Confirm'),
                  onPressed: () {
                    Box box = Hive.box("texture_logs");
                    box.clear();
                    Navigator.of(context).pop(SampleList());
                  },
                ),
              ],
            );
          });
    }

//    if (allSitesNames.contains("BaseSite")){
//      print("contains");
//    }

    return Container(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Sample List",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            Container(
              width: 50,
              child: FlatButton(
                child: Icon(Icons.more_vert),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Credits()),
                  );
                },
              ),
            )
          ],
        ),
        backgroundColor: Colors.grey[300],
        elevation: 2.0,
        actions: <Widget>[],
      ),
      body: TextureList(),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FlatButton.icon(
            onPressed: () => _showAddSamplePanel(),
            icon: Icon(Icons.add),
            label: Text('Add'),
          ),
          FlatButton.icon(
            onPressed: () {
              createAlertDialog(context);
            },
            icon: Icon(Icons.delete),
            label: Text('Delete All'),
          ),
          FlatButton.icon(
            onPressed: () {
              print("Export Data");
//              sendEmail(baseSite);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Credits()),
              );
            },
            icon: Icon(Icons.import_export),
            label: Text('Export Data'),
          ),
        ],
      ),
    ));
  }

}




class TextureList extends StatefulWidget {
  @override
  _TextureListState createState() => _TextureListState();
}

class _TextureListState extends State<TextureList> {


  Color getColor(int sand, int silt, int clay) {
    int R = (225*sand + 225*clay)~/100;
    int G = (225*sand + 225*silt)~/100;
    int B = (225*silt + 225*clay)~/100;
    return Color.fromRGBO(R, G, B, 1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Hive.openBox('texture_logs'),
        builder: (BuildContext context, AsyncSnapshot snapshot){

          if ((snapshot.connectionState == ConnectionState.done)){
            if (snapshot.hasError){
              return Text(snapshot.error.toString());
            }else{
              return ValueListenableBuilder(
                  valueListenable: Hive.box("texture_logs").listenable(),
                  builder: (context, textureLogBox, widget){


                    return ListView.builder(
                      reverse: true,
                      itemCount: textureLogBox.length,
                      itemBuilder: (BuildContext context, int index) {
                        final tLog = textureLogBox.getAt(textureLogBox.length - 1 - index) as Log;
                        Map quantityMap = {};
                        tLog.quantity.forEach((quant) {
                          quantityMap[quant.label] = quant.value;
                        });

                        return SampleListTile(textureLog: tLog, color: getColor(quantityMap["sand"].toInt(), quantityMap["silt"].toInt(), quantityMap["clay"].toInt()),excludeList: ["sand", "silt", "clay"],);
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

//  @override
//  void dispose() {
//    Hive.close();
//    super.dispose();
//  }

}

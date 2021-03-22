import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:soil_mate/models/log.dart';
import 'package:soil_mate/models/taxonomy_term.dart';
import 'package:soil_mate/models/texture_models.dart';
import 'package:soil_mate/screens/side_bar/drawer.dart';
import 'package:soil_mate/services/location_service.dart';
import 'package:soil_mate/services/send_email.dart';
import 'package:soil_mate/services/sizes_and_themes.dart';
import 'package:soil_mate/widgets/sample_list_tile.dart';
import 'package:soil_mate/widgets/sample_summary_container.dart';
import 'dart:async';
import 'credits.dart';
import 'dart:io';

class SampleList extends StatefulWidget{
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
  PickedFile imageFile = PickedFile("assets/placeholder.png");
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {

    Future addTextureLog() async {
      final taxonomyTermBox = Hive.box("taxonomy_term");
      TaxonomyTerm taxonomyTerm = taxonomyTermBox.get(selectedTexture.key);
      Box box = Hive.box("texture_logs");

      Position pos = await determinePosition();
      GeoField geoField = GeoField(lat: pos.latitude, lon: pos.longitude);

      TaxonomyTerm percentUnit = TaxonomyTerm(tid: 15, name: "%", description: "percentage", parent: [], parents_all: []);
      TaxonomyTerm cmUnit = TaxonomyTerm(tid: 18, name: "cm", description: "Center meters", parent: [], parents_all: []);

      List<Quantity> selectedQuanties = [
        Quantity(measure: "value", value: selectedTexture.sand.toDouble(), units: percentUnit, label: "sand"),
        Quantity(measure: "value", value: selectedTexture.silt.toDouble(), units: percentUnit, label: "silt"),
        Quantity(measure: "value", value: selectedTexture.clay.toDouble(), units: percentUnit, label: "clay"),
        Quantity(measure: "value", value: depthUpper.toDouble(), units: cmUnit, label: "Upper Depth"),
        Quantity(measure: "value", value: depthLower.toDouble(), units: cmUnit, label: "Lower Depth"),
      ];


      Log newTextureLog = Log(
          id: increment,
          name: selectedTexture.name,
          type: "texture_observation",
          timestamp: DateTime.now().toString(),
          images: [imageFile.path],
          notes: "",
          geofield: geoField,
          log_category: [taxonomyTerm],
          quantity: selectedQuanties);
      box.put(increment, newTextureLog);
      increment = increment +1;

      imageFile = PickedFile("assets/placeholder.png");
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

      _customTextFieldDecoration(){
        return InputDecoration(
          contentPadding: EdgeInsets.all(3),
          isDense: true,
          counterText: '',
          border: InputBorder.none,
          filled: true,
        );
      }


      showModalBottomSheet<dynamic>(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState
                    /*You can rename this!*/) {
              return CustomScrollView(
                shrinkWrap: true,
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            childAspectRatio: (3 / 1),
                            crossAxisCount: 3,
                            children: AusClassification()
                                .getTextureList()
                                .map((texture) => Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.all(0) ,
                                          backgroundColor: texture.getColor().withOpacity(0.5),
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: texture.getColor(),
                                                  width: 2,
                                                  style: BorderStyle.solid),
                                              borderRadius: BorderRadius.circular(15)),
                                        ),
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
                          SizedBox(height: displayHeight(context)*0.01,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex:1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Upper depth: ',
                                          style: bodyTextStyle(context),
                                        ),
                                        Container(
                                          width: displayWidth(context)*0.12,
                                          height: displayWidth(context)*0.06,
                                          child: TextFormField(
                                            style: bodyTextStyle(context),
                                            maxLength: 3,

                                            decoration: _customTextFieldDecoration(),
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
                                        Container(
                                          width: displayWidth(context)*0.12,
                                          height: displayWidth(context)*0.06,
                                          child: TextFormField(
                                            style: bodyTextStyle(context),
                                            maxLength: 3,
                                            decoration: _customTextFieldDecoration(),
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
                                        Container(
                                          width: displayWidth(context)*0.18,
                                          height: displayWidth(context)*0.06,
                                          child: TextFormField(
                                            style: bodyTextStyle(context),
                                            maxLength: 5,
                                            decoration: _customTextFieldDecoration(),
                                            controller: txt4,
                                            autovalidateMode: AutovalidateMode.always,
                                            keyboardType: TextInputType.number,
                                            onChanged: (val) {
                                              setState(() {
                                                increment = int.parse(val == ''? increment.toString(): val);
                                                print(increment);
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: SampleSummary(
                                  selectedTexture: this.selectedTexture,
                                  depthUpper: depthUpper,
                                  depthLower: depthLower,
                                  sampleID: increment,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: displayHeight(context)*0.01,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Stack(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 27,
                                    backgroundImage: imageFile == null ? AssetImage("assets/placeholder.png"): FileImage(File(imageFile.path)),
                                  ),
                                  IconButton(
                                    onPressed: ()
                                    async{
                                      final pickedFile = await _picker.getImage(
                                        source: ImageSource.camera,
                                      );
                                      File file = File(pickedFile.path);
                                      Directory dir = await getApplicationDocumentsDirectory();
                                      File newFile = await file.copy("${dir.path}" +"/image$increment.jpg");
                                      print(newFile.path);
                                      file.delete();
                                      setState(() {
                                        PickedFile newPickedFile = PickedFile(newFile.path);
                                        imageFile = newPickedFile;
                                      });
                                    },
                                    icon: Icon(Icons.camera_alt),
                                    iconSize: 40,
                                    color: Colors.pink,
                                  ),
                                ],
                              ),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.blueAccent, // background
                                        onPrimary: Colors.white, // foreground
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                                        minimumSize: Size(150,50),
                                        elevation: 10.0,

                                      ),
                                      child: Text("Add", style: TextStyle(fontSize: 30),),
                                      onPressed: () {
                                        addTextureLog();
                                        Navigator.pop(context);
                                      })),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
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
          drawer: SizedBox(
            width: displayWidth(context)*0.7,
            child: Drawer(
              child: CustomDraw(),
            ),
          ),
          appBar: AppBar(title: Text(
            "Soil Texture Samples",
            style: headingTextStyle(context),
          ),),

          body: TextureList(),
          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {

                  Box box = Hive.box("texture_logs");

                  if (!box.isEmpty){
                  List<int> keyList = box.keys.toList().map((e) => int.parse(e.toString())).toList();
                  increment = keyList.reduce(max) +1;

                  } else {
                    increment = 0;
                  }
                  _showAddSamplePanel();
                },
                icon: Icon(Icons.add, color: Colors.black87,),
                label: Text('Add', style: TextStyle(color: Colors.black87)),
              ),
              TextButton.icon(
                onPressed: () {
                  createAlertDialog(context);
                },
                icon: Icon(Icons.delete, color: Colors.black87,),
                label: Text('Delete All', style: TextStyle(color: Colors.black87)),
              ),
              TextButton.icon(
                onPressed: () {
                  print("Export Data");
                  Box logBox = Hive.box("texture_logs");
                  List logKeys = logBox.keys.toList();
                  List<Log> logList = [];
                  logKeys.forEach((k) {
                    logList.add(logBox.get(k) as Log);
                  });
                  sendEmail(logList);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Credits()),
                  );
                },
                icon: Icon(Icons.import_export, color: Colors.black87,),
                label: Text('Export Data', style: TextStyle(color: Colors.black87)),
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

                        return SampleListTile(
                          sampleLog: tLog,
                          color: getColor(quantityMap["sand"].toInt(), quantityMap["silt"].toInt(), quantityMap["clay"].toInt()),
                          excludeList: ["sand", "silt", "clay"],
                          boxname: "texture_logs",
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

//  @override
//  void dispose() {
//    Hive.close();
//    super.dispose();
//  }

}

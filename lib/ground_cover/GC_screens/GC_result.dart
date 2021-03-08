import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:soil_mate/ground_cover/GC_models/GC_model.dart';
import 'package:soil_mate/ground_cover/GC_screens/GC_form.dart';
import 'package:soil_mate/models/log.dart';
import 'package:soil_mate/models/taxonomy_term.dart';
import 'package:soil_mate/services/location_service.dart';
import 'dart:io';

import 'package:soil_mate/services/navigation_bloc.dart';
import 'package:soil_mate/services/sizes_and_themes.dart';
import 'package:soil_mate/widgets/sample_list_tile.dart';


const String GC_LOGS = "gc_logs";


class GroundCoverResult extends StatefulWidget   with NavigationStates{
  GroundCoverModel model;

  GroundCoverResult({this.model});

  @override
  _GroundCoverResultState createState() => _GroundCoverResultState();
}

class _GroundCoverResultState extends State<GroundCoverResult> {
  List<GroundCoverModel> GroundCoverList = [];

  Map<String, int> mySpecies = {
    'Grasses Perennial': 0,
    'Grasses Annual': 0,
    'Forbs Perennial': 0,
    'Forbs Annual': 0,
    'Legumes' : 0,
    'Native Pasture' : 0,
  };


  double coverPercentage = 0.0;
  double weedsRatio  = 0.0;
  double coverHeight = 0.0;


  @override
  Widget build(BuildContext context) {


    Future addGroundCoverLog() async {
      final taxonomyTermBox = Hive.box("taxonomy_term");
      TaxonomyTerm taxonomyTerm = taxonomyTermBox.get("ground_cover");
      Box GCbox = Hive.box(GC_LOGS);
      int newID = GCbox.length;
      Position pos = await determinePosition();
      GeoField geoField = GeoField(lat: pos.latitude, lon: pos.longitude);

      TaxonomyTerm percentUnit = TaxonomyTerm(tid: 15, name: "%", description: "percentage", parent: [], parents_all: []);
      TaxonomyTerm cmUnit = TaxonomyTerm(tid: 18, name: "cm", description: "Center meters", parent: [], parents_all: []);
      TaxonomyTerm countUnit = TaxonomyTerm(tid: 69, name: "count", description: "Number of items", parent: [], parents_all: []);

      List<Quantity> selectedQuanties = [
        // percentages
        Quantity(measure: "value", value: coverPercentage, units: percentUnit, label: "Cover Percentage"),
        Quantity(measure: "value", value: weedsRatio, units: percentUnit, label: "Weed Ratio"),
        Quantity(measure: "value", value: coverHeight, units: cmUnit, label: "Cover Height"),
        // Types
        Quantity(measure: "count", value: mySpecies["Forbs Annual"].toDouble(), units: countUnit, label: "Forbs Annual"),
        Quantity(measure: "count", value: mySpecies["Forbs Perennial"].toDouble(), units: countUnit, label: "Forbs Perennial"),
        Quantity(measure: "count", value: mySpecies["Grasses Annual"].toDouble(), units: countUnit, label: "Grasses Annual"),
        Quantity(measure: "count", value: mySpecies["Grasses Perennial"].toDouble(), units: countUnit, label: "Grasses Perennial"),
        Quantity(measure: "count", value: mySpecies["Native Pasture"].toDouble(), units: countUnit, label: "Native Pasture"),
        Quantity(measure: "count", value: mySpecies["Legumes"].toDouble(), units: countUnit, label: "Legumes"),
        Quantity(measure: "count", value: mySpecies.values.reduce((v, e) => v+e).toDouble(), units: countUnit, label: "Total Species Diversity"),
      ];


      Log newGroundCoverLog = Log(
          id: newID,
          name: "",
          type: "ground_cover_observation",
          timestamp: DateTime.now().toString(),
          notes: "",
          geofield: geoField,
          log_category: [taxonomyTerm],
          quantity: selectedQuanties);
      GCbox.put(newID, newGroundCoverLog);
    }


    void _showGroundCoverPanel() {
      final _formKey = GlobalKey<FormState>();
      showModalBottomSheet<dynamic>(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  sliderColor(value) {
                    if (value < 30) {
                      return Colors.green[200];
                    } if (value < 70) {
                      return Colors.green[400];
                    }
                    else {
                      return Colors.green[700];
                    }
                  }


                  return Scaffold(
                    body: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20,30,10,10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: displayHeight(context)*0.08,),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.grey[200],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10, top: 8),
                                    child: Text(
                                      'Percentage of Ground Cover',
                                      style: bodyTextStyle(context),
                                    ),
                                  ),
                                  Container(
                                    //margin: EdgeInsets.symmetric(horizontal: 10),
                                    color: Colors.white,
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        trackShape: RoundedRectSliderTrackShape(),
                                        trackHeight: 4.0,
                                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                        overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                                        tickMarkShape: RoundSliderTickMarkShape(),
                                        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                                        valueIndicatorTextStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Slider.adaptive(
                                        value: coverPercentage,
                                        onChanged: (newCoverPercentage) {
                                          setState(() => coverPercentage = newCoverPercentage);
                                        },
                                        label: '${coverPercentage.round()} %',
                                        divisions: 20,
                                        min: 0,
                                        max: 100,
                                        activeColor: sliderColor(coverPercentage),
                                        inactiveColor: sliderColor(coverPercentage),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10, top: 8),
                                    child: Text('Height of Cover', style: bodyTextStyle(context),),
                                  ),
                                  Container(
                                    //margin: EdgeInsets.symmetric(horizontal: 10),
                                    color: Colors.white,
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        trackShape: RoundedRectSliderTrackShape(),
                                        trackHeight: 4.0,
                                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                        overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                                        tickMarkShape: RoundSliderTickMarkShape(),
                                        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                                        valueIndicatorTextStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Slider.adaptive(
                                        value: coverHeight,
                                        onChanged: (newCoverHeight) {
                                          setState(() => coverHeight = newCoverHeight);
                                        },
                                        label: '${coverHeight.round()} cm',
                                        min: 0,
                                        max: 100,
                                        divisions: 20,
                                        activeColor: sliderColor(coverHeight),
                                        inactiveColor: sliderColor(coverHeight),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10, top: 8),
                                    child: Text('Percentage of Weeds from total vegetation', style: bodyTextStyle(context),),
                                  ),
                                  Container(
                                    //margin: EdgeInsets.symmetric(horizontal: 10),
                                    color: Colors.white,
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        trackShape: RoundedRectSliderTrackShape(),
                                        trackHeight: 4.0,
                                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                        overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                                        tickMarkShape: RoundSliderTickMarkShape(),
                                        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                                        valueIndicatorTextStyle: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Slider.adaptive(
                                        value: weedsRatio,
                                        onChanged: (newWeeds) {
                                          setState(() => weedsRatio = newWeeds);
                                        },
                                        label: '${weedsRatio.round()} %',
                                        min: 0,
                                        max: 100,
                                        divisions: 20,
                                        activeColor: sliderColor(weedsRatio),
                                        inactiveColor: sliderColor(weedsRatio),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),


                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: mySpecies.length,
                                itemBuilder: (context, index) {
                                  String speciesName = mySpecies.keys.toList()[index];
                                  int speciesCount = mySpecies[speciesName];
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      //color: Colors.grey[200],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(speciesName, style: bodyTextStyle(context),),
                                        Row(
                                          children: [
                                            RawMaterialButton(
                                              //elevation: 2.0,
                                              // fillColor: Color(0xff2C9C0A),
                                              // shape: CircleBorder(),
                                              child: Icon(Icons.remove),
                                              onPressed: () {
                                                if (mySpecies[speciesName] > 0 ){
                                                  mySpecies[speciesName] =
                                                      mySpecies[speciesName] - 1;
                                                  setState(() {});
                                                }
                                              },
                                            ),
                                            Text(speciesCount.toString(), style: bodyTextStyle(context),),
                                            RawMaterialButton(
                                              //elevation: 2.0,
                                              // fillColor: Color(0xff2C9C0A),
                                              // shape: CircleBorder(),
                                              child: Icon(Icons.add),
                                              onPressed: () {
                                                mySpecies[speciesName] = mySpecies[speciesName] + 1;
                                                setState(() {

                                                });
                                              },
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                  );
                                }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //imageProfile(context),
                                RaisedButton(
                                  color: Colors.blueAccent,
                                  onPressed: () {
                                    addGroundCoverLog();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          });
    }

    _createDeleteGroundCoverDialog(BuildContext context) {
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
                    Navigator.pop(context);
                  },
                ),
                MaterialButton(
                  child: Text('Confirm'),
                  onPressed: () {
                    Box groundCoverLog = Hive.box(GC_LOGS);
                    groundCoverLog.clear();
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }


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
            child: Text('Delete'),
            onPressed: () {
              _createDeleteGroundCoverDialog(context);

            }
          ),
          ElevatedButton(
            child: Text('Add Sample'),
              onPressed: () {
                _showGroundCoverPanel();
              }
          ),
        ],
      ),
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
    List<String> ignoreSpecies = [
      'Grasses Perennial',
      'Grasses Annual',
      'Forbs Perennial',
      'Forbs Annual',
      'Legumes',
      'Native Pasture',
    ];

    return FutureBuilder(
        future: Hive.openBox(GC_LOGS),
        builder: (BuildContext context, AsyncSnapshot snapshot){


          if (snapshot.connectionState == ConnectionState.done){
            if (snapshot.hasError){
              return Text(snapshot.error.toString());
            }else{
              return ValueListenableBuilder(
                  valueListenable: Hive.box(GC_LOGS).listenable(),
                  builder: (context, groundCoverLogBox, widget){
                    return ListView.builder(
                      itemCount: groundCoverLogBox.length,
                      itemBuilder: (BuildContext context, int index) {
                        final gcLog = groundCoverLogBox.getAt(index) as Log;

                        return SampleListTile(textureLog: gcLog, color: Colors.greenAccent, excludeList: ignoreSpecies,);
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

















import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:soil_mate/models/GC_model.dart';
import 'package:soil_mate/models/log.dart';
import 'package:soil_mate/models/taxonomy_term.dart';
import 'package:soil_mate/screens/credits.dart';
import 'package:soil_mate/screens/side_bar/drawer.dart';
import 'package:soil_mate/services/location_service.dart';
import 'package:soil_mate/services/send_email.dart';
import 'package:soil_mate/services/sizes_and_themes.dart';
import 'package:soil_mate/widgets/sample_list_tile.dart';


const String GC_LOGS = "gc_logs";


class GroundCoverResult extends StatefulWidget {
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
  };


  double coverPercentage = 0.0;
  double weedsRatio  = 0.0;
  double coverHeight = 0.0;


  @override
  Widget build(BuildContext context) {


    Future addGroundCoverLog() async {
      final taxonomyTermBox = Hive.box("taxonomy_term");
      // TaxonomyTerm taxonomyTerm = taxonomyTermBox.get("ground_cover");
      TaxonomyTerm taxonomyTerm = TaxonomyTerm(tid: 57, name: "ground_cover", description: "", parent: [], parents_all: []);
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


                  return Form(
                    key: _formKey,
                    child: CustomScrollView(
                      shrinkWrap: true,
                      slivers: <Widget>[
                        SliverPadding(
                          padding: const EdgeInsets.all(20.0),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate(
                              <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 10, top: 8),
                                  child: Text(
                                    'Percentage of Ground Cover',
                                    style: bodyTextStyle(context),
                                  ),
                                ),
                                Container(
                                  color: Colors.white,
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      trackShape: RoundedRectSliderTrackShape(),
                                      trackHeight: 4.0,
                                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                      overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                                      tickMarkShape: RoundSliderTickMarkShape(),
                                      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                                      valueIndicatorTextStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Slider(
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
                                  color: Colors.white,
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      trackShape: RoundedRectSliderTrackShape(),
                                      trackHeight: 4.0,
                                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                      overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                                      tickMarkShape: RoundSliderTickMarkShape(),
                                      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                                      valueIndicatorTextStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Slider(
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
                                  color: Colors.white,
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      trackShape: RoundedRectSliderTrackShape(),
                                      trackHeight: 4.0,
                                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                      overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                                      tickMarkShape: RoundSliderTickMarkShape(),
                                      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                                      valueIndicatorTextStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: Slider(
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
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: mySpecies.length,
                                    itemBuilder: (context, index) {
                                      String speciesName = mySpecies.keys.toList()[index];
                                      int speciesCount = mySpecies[speciesName];
                                      return Container(
                                        decoration: BoxDecoration(
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(speciesName, style: bodyTextStyle(context),),
                                            Row(
                                              children: [
                                                RawMaterialButton(
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
                                          addGroundCoverLog();
                                          Navigator.pop(context);
                                        }
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
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
      drawer: SizedBox(
        width: displayWidth(context)*0.7,
        child: Drawer(
          child: CustomDraw(),
        ),
      ),
      appBar: AppBar(title: Text(
        "Ground Cover Samples",
        style: headingTextStyle(context),
      ),),
      body: Column(
        children: [
          Expanded(child: GroundCoverTile()),
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton.icon(
            onPressed: () => _showGroundCoverPanel(),
            icon: Icon(Icons.add, color: Colors.black87),
            label: Text('Add', style: TextStyle(color: Colors.black87)),
          ),
          TextButton.icon(
            onPressed: () {
              _createDeleteGroundCoverDialog(context);
            },
            icon: Icon(Icons.delete, color: Colors.black87,),
            label: Text('Delete All', style: TextStyle(color: Colors.black87),),
          ),
          TextButton.icon(
            onPressed: () {
              print("Export Data");
              Box _logBox = Hive.box("gc_logs");
              List _logKeys = _logBox.keys.toList();
              List<Log> _logList = [];
              _logKeys.forEach((k) {
                _logList.add(_logBox.get(k) as Log);
              });
              sendEmail(_logList);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Credits()),
              );
            },
            icon: Icon(Icons.import_export, color: Colors.black87),
            label: Text('Export Data', style: TextStyle(color: Colors.black87)),
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


  Color _getColor(int groundCoverPercentage) {
    if (groundCoverPercentage > 99){
      groundCoverPercentage = 99;
    }
    if (groundCoverPercentage < 0){
      groundCoverPercentage = 0;
    }
    int lowR = 196;
    int lowG = 52;
    int lowB = 64;
    int highR = 20;
    int highG = 230;
    int highB = 3;

    double mag = (groundCoverPercentage.toDouble())/100.0;

    int R = lowR + ((highR.toDouble() - lowR.toDouble())*mag).toInt();
    int G = lowG + ((highG.toDouble() - lowG.toDouble())*mag).toInt();
    int B = lowB + ((highB.toDouble() - lowB.toDouble())*mag).toInt();
    return Color.fromRGBO(R, G, B, 1);
  }


  @override
  Widget build(BuildContext context) {
    List<String> ignoreSpecies = [
      'Grasses Perennial',
      'Grasses Annual',
      'Forbs Perennial',
      'Forbs Annual',
      'Legumes',
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
                      reverse: true,
                      itemCount: groundCoverLogBox.length,
                      itemBuilder: (BuildContext context, int index) {
                        final gcLog = groundCoverLogBox.getAt(groundCoverLogBox.length - 1 - index) as Log;

                        Map quantityMap = {};
                        gcLog.quantity.forEach((quant) {
                          quantityMap[quant.label] = quant.value;
                        });

                        return SampleListTile(textureLog: gcLog, color: _getColor(quantityMap["Cover Percentage"].toInt()), excludeList: ignoreSpecies,);
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

















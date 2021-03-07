import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:soil_mate/models/texture_models.dart';
import 'package:soil_mate/screens/add_sample.dart';
import 'package:soil_mate/services/navigation_bloc.dart';
import 'package:soil_mate/services/send_email.dart';
import 'package:soil_mate/services/site_database.dart';
import 'package:soil_mate/models/site.dart';
import 'package:soil_mate/models/sample.dart';
import 'package:soil_mate/services/sizes_and_themes.dart';
import 'package:soil_mate/widgets/sample_summary_container.dart';
import 'package:soil_mate/widgets/texture_button.dart';
import 'dart:async';
import 'credits.dart';
import '../widgets/sample_list_tile.dart';


class SampleList extends StatefulWidget with NavigationStates{

  @override
  _SampleListState createState() => _SampleListState();
}

class _SampleListState extends State<SampleList> {
  List<Site> allSites = [];
  bool dataLoaded = false;
  String baseSiteKey =  "BaseSite";
  Site baseSite;
  List<Sample> baseSamples = [];
  List<Sample> reverseBaseSamples = [];
  TextureClass selectedTexture = AusClassification().getTextureList()[0];
  int depthUpper = 0;
  int depthLower = 10;

  @override
  Widget build(BuildContext context) {

    //Add samples to sites
    Site iSite = Site(
      name: baseSiteKey,
      classification: "aus",
      rawSamples: [],
      increment: 0,
    );

    Function stateSetter(){
      setState(() {

      });
    }

    Future<void> loadData() async {
      bool alreadySite = await saveSite(iSite);
      if (alreadySite){
        print("Cant use this name; already exists");
      }
      this.allSites = await getSites();
      print(this.allSites);
      dataLoaded = true;
      print("Data loaded");
//      List<dynamic> allSitesNames = allSites.map((s) => s.name).toList();
//      print(allSitesNames);
      List<dynamic> baseSiteList = allSites.where((s) => s.name == baseSiteKey).toList();
      baseSite = baseSiteList[0];
      baseSamples = baseSite.samples;
      reverseBaseSamples = baseSamples.reversed.toList();
      print("baseSamples");
      print(baseSamples);
      setState(() {});
    }



    if (!dataLoaded){
      print("trying to load");
      loadData();
    }


    Future<void> deleteSamples() async {
      overrideSite(iSite);
      loadData();

    }




    var txt2 = TextEditingController();
    txt2.text = depthUpper.toString();
    txt2.selection = TextSelection.fromPosition(
        TextPosition(offset: depthUpper.toString().length));

    var txt3 = TextEditingController();
    txt3.text = depthLower.toString();
    txt3.selection = TextSelection.fromPosition(
        TextPosition(offset: depthLower.toString().length));

    var txt4 = TextEditingController();
    txt4.text = baseSite.increment.toString();
    txt4.selection = TextSelection.fromPosition(
        TextPosition(offset: baseSite.increment.toString().length));

    Function setTexture(TextureClass tc) {
      this.selectedTexture = tc;
      setState(() {
        this.selectedTexture = tc;
      });
    }






    Future<Position> _determinePosition() async {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permantly denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          return Future.error(
              'Location permissions are denied (actual value: $permission).');
        }
      }

      return await Geolocator.getCurrentPosition();
    }







    void _showAddSamplePanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(17),
          child: Wrap(
            runSpacing: 17,
            children: <Widget>[
              Text(
                'Soil Texture',
                style: headingTextStyle(context),
              ),
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                childAspectRatio: (3 / 1),
                crossAxisCount: 3,
                children: AusClassification()
                    .getTextureList()
                    .map((texture) => TextureButton(
                  textureClass: texture,
                  setTextureFunction: setTexture,
                ))
                    .toList(),
              ),
              Text(
                'Depth Range',
                style: headingTextStyle(context),
              ),
              Row(
                children: [
                  Text('Upper depth: ',
                    style: bodyTextStyle(context),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tight(Size((0.06 * displayHeight(context)), (0.035 * displayHeight(context)))),
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
                  Text('Lower depth: ',
                    style: bodyTextStyle(context),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tight(Size((0.06 * displayHeight(context)), (0.035 * displayHeight(context)))),
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
                    'Sample ID',
                    style: headingTextStyle(context),
                  ),
                  RaisedButton(
                    child: Text("Save"),

                      onPressed: (){
                        Future<void> saveDataPushHome() async {
                          Position position = await _determinePosition();

                          Sample s = Sample(
                            lat: position.latitude,
                            lon: position.longitude,
                            textureClass: selectedTexture.name,
                            depthShallow: depthUpper,
                            depthDeep: depthLower,
                            sand: selectedTexture.sand,
                            silt: selectedTexture.silt,
                            clay: selectedTexture.clay,
                            id: baseSite.increment,
                          );
                          baseSite.addSample(s);
                          baseSite.increment = baseSite.increment + 1;

                          // TODO need to add new sample to base site and setState (refresh)
                          // TODO need to pop sheet context
                          // TODO need to save to hive
                          overrideSite(baseSite);
                          loadData();
                          Navigator.pop(context);

                        }
                        saveDataPushHome();

                  })
                ],
              ),
              Row(
                children: [
                  Text('ID: ',
                    style: bodyTextStyle(context),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tight(Size((0.1 * displayHeight(context)), (0.035 * displayHeight(context)))),
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
                          baseSite.increment = int.parse(val);
                          print(baseSite.increment);
                        });
                      },
                    ),
                  ),
                ],
              ),
              Center(child: SampleSummary(
                selectedTexture: selectedTexture,
                depthUpper: depthUpper,
                depthLower: depthLower,
                sampleID: baseSite.increment,
              )),
            ],
          ),
        );
      });
    }

  //------------------------------------------------------------------------------------

    Color getColor(int sand, int silt, int clay) {
    int R = (225*sand + 225*clay)~/100;
    int G = (225*sand + 225*silt)~/100;
    int B = (225*silt + 225*clay)~/100;
    return Color.fromRGBO(R, G, B, 1);
  }





    createAlertDialog(BuildContext context) {
      return showDialog(context: context, builder: (context) {
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
                print(baseSamples);
                deleteSamples();
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
          actions: <Widget>[
            
          ],
        ),
        body: ListView.builder(
          reverse: true,
            itemCount: reverseBaseSamples.length,
            itemBuilder: (context, index){
              return SampleListTile(
                baseSamples: baseSamples,
                baseSite: baseSite,
                reverseBaseSamples: reverseBaseSamples,
                index: index,
              );
            }
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlatButton.icon(
              onPressed: () => _showAddSamplePanel(),
                icon: Icon(Icons.add),
                label: Text('Add'),
            ),
            FlatButton.icon(
              onPressed: (){
                createAlertDialog(context);
              },
              icon: Icon(Icons.delete),
              label: Text('Delete All'),

            ),
            FlatButton.icon(
              onPressed: (){
                print("Export Data");
                sendEmail(baseSite);
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
      )
    );
  }
}

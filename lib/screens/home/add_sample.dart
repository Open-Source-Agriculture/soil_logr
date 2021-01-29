import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:soil_mate/models/texture_models.dart';
import 'package:soil_mate/screens/home/sample_list.dart';
import 'package:soil_mate/models/sample.dart';
import 'package:soil_mate/models/site.dart';
import 'package:soil_mate/services/site_database.dart';

import '../../models/texture_models.dart';
import 'package:geolocator/geolocator.dart';
import '../../widgets/add_sample_widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddSamplePage(title: 'Add Sample'),
    );
  }
}

class AddSamplePage extends StatefulWidget {
  AddSamplePage({Key key, this.title = 'Add Sample'}) : super(key: key);

  final String title;

  @override
  _AddSamplePageState createState() => _AddSamplePageState();
}

class _AddSamplePageState extends State<AddSamplePage> {
  double sampledLat = 37.42796133580664;
  double sampledLon = -122.085749655962;
  List<Sample> samples = [];
  int depthUpper = 0;
  int depthLower = 10;
  Site site = Site(
      name: 'placeHolder', classification: "aus", rawSamples: [], increment: 0);

  @override
  List<Site> allSites = [];
  bool dataLoaded = false;
  String baseSiteKey = "BaseSite";
  List<Sample> baseSamples = [];

  TextureClass selectedTexture = AusClassification().getTextureList()[0];

  bool sendingSample = false;

  @override
  Widget build(BuildContext context) {
    Site iSite = Site(
        name: baseSiteKey, classification: "aus", rawSamples: [], increment: 0);

    Future<void> loadData() async {
      bool alreadySite = await saveSite(iSite);
      if (alreadySite) {
        print("Cant use this name; already exists");
      }
      this.allSites = await getSites();
      dataLoaded = true;
      List<dynamic> baseSiteList =
          allSites.where((s) => s.name == baseSiteKey).toList();
      Site baseSite = baseSiteList[0];
      site = baseSite;
      baseSamples = baseSite.samples;
      print(baseSamples);
      setState(() {});
    }

    if (!dataLoaded) {
      print("trying to load");
      loadData();
    }

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

    var txt2 = TextEditingController();
    txt2.text = depthUpper.toString();
    txt2.selection = TextSelection.fromPosition(
        TextPosition(offset: depthUpper.toString().length));

    var txt3 = TextEditingController();
    txt3.text = depthLower.toString();
    txt3.selection = TextSelection.fromPosition(
        TextPosition(offset: depthLower.toString().length));

    var txt4 = TextEditingController();
    txt4.text = site.increment.toString();
    txt4.selection = TextSelection.fromPosition(
        TextPosition(offset: site.increment.toString().length));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.grey[300],
        elevation: 2.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Wrap(
          runSpacing: 17,
          children: <Widget>[
            Text(
              'Soil Texture',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Container(
              height: 180,
              child: GridView.count(
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
            ),
            Text(
              'Depth Range',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Row(
              children: [
                Text('Upper depth: '),
                ConstrainedBox(
                  constraints: BoxConstraints.tight(Size(55, 25)),
                  child: TextFormField(
                    maxLength: 3,
                    decoration: InputDecoration(counterText: ''),
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
                Text('Lower depth: '),
                ConstrainedBox(
                  constraints: BoxConstraints.tight(Size(55, 25)),
                  child: TextFormField(
                    maxLength: 3,
                    decoration: InputDecoration(counterText: ''),
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
            Text(
              'Sample ID',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Row(
              children: [
                Text('ID: '),
                ConstrainedBox(
                  constraints: BoxConstraints.tight(Size(100, 25)),
                  child: TextFormField(
                    maxLength: 5,
                    decoration: InputDecoration(counterText: ''),
                    controller: txt4,
                    autovalidateMode: AutovalidateMode.always,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() {
                        site.increment = int.parse(val);
                        print(site.increment);
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
              sampleID: site.increment,
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Submit'),
        icon: Icon(Icons.done),
        elevation: 2,
        onPressed: () {
          if (sendingSample != true) {
            sendingSample = true;
            setState(() {
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
                  id: site.increment,
                );
                site.addSample(s);
                site.increment = site.increment + 1;

                await overrideSite(site);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SampleList()),
                );
              }

              saveDataPushHome();
            });
          }
        },
      ),
    );
  }
}
// setState(() {
// // print(locationDict.toString());
// // if (locationDict[LAT] != null){
// //   sampledLat = locationDict[LAT];
// //   sampledLon = locationDict[LON];

// site.addSample(s);
// print(site.samples.map((e) => e.textureClass));
// site.increment = site.increment + 1;
// print(site.increment);

// saveDataPushHome();
//
// // } else {
// //
// //   Navigator.push(
// //     context,
// //     MaterialPageRoute(builder: (context) => SampleList()),
// //   );
// // }
// },
// );
// );



import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:soil_mate/screens/loading.dart';
import '../../services/sizes_and_themes.dart';
import 'GC_sample_list.dart';
import '../GC_models/GC_site.dart';
import '../GC_models/GC_sample.dart';
import '../GC_services/GC_site_database.dart';

class AddGroundCoverSample extends StatefulWidget {
  @override
  _AddGroundCoverSampleState createState() => _AddGroundCoverSampleState();
}

class _AddGroundCoverSampleState extends State<AddGroundCoverSample> {

  double sampledLat = 37.42796133580664;
  double sampledLon = -122.085749655962;
  List<GCSample> samples = [];
  double coverHeight = 0;
  double coverPercentage = 0;
  double weeds = 0;
  double desirables = 100;
  String speciesList = 'species';
  GCSite site = GCSite(
      GCname: 'placeHolder', rawGCSamples: [], GCincrement: 0);

  @override
  List<GCSite> allCoverSites = [];
  bool dataLoaded = false;
  String baseCoverSiteKey = "CoverBaseSite";
  List<GCSample> baseCoverSamples = [];


  bool sendingSample = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {


    GCSite iSite = GCSite(
        GCname: baseCoverSiteKey,  rawGCSamples: [], GCincrement: 0);

    Future<void> loadData() async {
      bool alreadySite = await saveGCSite(iSite);
      if (alreadySite) {
        print("Cant use this name; already exists");
      }
      this.allCoverSites = await getGCSites();
      dataLoaded = true;
      List<dynamic> baseSiteList =
      allCoverSites.where((s) => s.GCname == baseCoverSiteKey).toList();
      GCSite baseSite = baseSiteList[0];
      site = baseSite;
      baseCoverSamples = baseSite.GCsamples;
      print(baseCoverSamples);
      setState(() {});
    }

    if (!dataLoaded) {
      print("trying to load ground cover");
      loadData();
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

    return Scaffold(
      appBar: AppBar(title: Text('Add Ground Cover Sample'),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Percentage of Ground Cover'),
              Slider(
                value: coverPercentage,
                onChanged: (newCoverPercentage) {
                  setState(() => coverPercentage = newCoverPercentage);
                },
                divisions: 10,
                label: '$coverPercentage %',
                min: 0,
                max: 100,
              ),
              Text('Height of Cover'),
              Slider(

                value: coverHeight,
                onChanged: (newCoverHeight) {
                  setState(() => coverHeight = newCoverHeight);
                },
                divisions: 10,
                label: '$coverHeight cm',
                min: 0,
                max: 100,
              ),
              Text('Percentage of Weeds from total vegetation'),
              Slider(
                value: weeds,
                onChanged: (newWeeds) {
                  setState(() => weeds = newWeeds);
                },
                divisions: 10,
                label: '$weeds %',
                min: 0,
                max: 100,
              ),
              Text("List of species (separate by ',')"),
              TextFormField(
                initialValue: speciesList,
                onChanged: (val) {
                  setState(() {
                    speciesList = val;
                    print(speciesList);
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: Text('Submit',
            style: headingTextStyle(context),
          ),
          icon: Icon(Icons.done,
            size: displayWidth(context) * 0.04,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Loading()),
            );
            if (sendingSample != true) {
              sendingSample = true;
              setState(() {
                Future<void> submitGroundCover() async {
                  Position position = await _determinePosition();

                  GCSample s = GCSample(
                    lat: position.latitude,
                    lon: position.longitude,
                    speciesList: speciesList,
                    coverHeight: coverHeight,
                    coverPercentage: coverPercentage,
                    weedsRatio: weeds,
                    gcId: site.GCincrement,
                  );
                  print(s.getGCData());
                  site.addSample(s);
                  site.GCincrement = site.GCincrement + 1;

                  await overrideGCSite(site);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddGroundCoverSample()),
                  );
                }
                submitGroundCover();
              });
            }
          }
      ),
    );
  }
}

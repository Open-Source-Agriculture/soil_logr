import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soil_mate/screens/home/add_sample.dart';
import 'package:soil_mate/services/send_email.dart';
import 'package:soil_mate/services/site_database.dart';
import 'package:soil_mate/models/site.dart';
import 'package:soil_mate/models/sample.dart';
import 'dart:async';
import 'credits.dart';
import '../../widgets/sample_list_tile.dart';


class SampleList extends StatefulWidget {

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




  @override
  Widget build(BuildContext context) {
    //Add samples to sites
    Site iSite = Site(
        name: baseSiteKey,
        classification: "aus",
        rawSamples: [],
        increment: 0,
    );

    Color getColor(int sand, int silt, int clay) {
    int R = (225*sand + 225*clay)~/100;
    int G = (225*sand + 225*silt)~/100;
    int B = (225*silt + 225*clay)~/100;
    return Color.fromRGBO(R, G, B, 1);
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
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddSamplePage()),
                  );
                },
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

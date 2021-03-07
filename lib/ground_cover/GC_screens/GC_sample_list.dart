import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soil_mate/services/navigation_bloc.dart';
import 'package:soil_mate/services/send_email.dart';
import 'package:soil_mate/ground_cover/GC_models/GC_site.dart';
import 'package:soil_mate/ground_cover/GC_models/GC_sample.dart';
import 'GC_add_sample.dart';
import 'package:soil_mate/ground_cover/GC_services/GC_site_database.dart';
import 'dart:async';
import 'package:soil_mate/screens/credits.dart';
import 'package:soil_mate/screens/home.dart';
import 'GC_add_sample.dart';



class GroundCoverSampleList extends StatefulWidget with NavigationStates{

  @override
  _GroundCoverSampleListState createState() => _GroundCoverSampleListState();
}

class _GroundCoverSampleListState extends State<GroundCoverSampleList> {
  List<GCSite> allCoverSites = [];
  bool dataLoaded = false;
  String baseCoverSiteKey =  "CoverBaseSite";
  GCSite baseCoverSite;
  List<GCSample> baseCoverSamples = [];
  List<GCSample> reverseBaseCoverSamples = [];




  @override
  Widget build(BuildContext context) {
    //Add samples to sites
    GCSite iSite = GCSite(
      GCname: baseCoverSiteKey,
      rawGCSamples: [],
      GCincrement: 0,
    );



    Future<void> loadData() async {
      bool alreadySite = await saveGCSite(iSite);
      if (alreadySite){
        print("Cant use this name; already exists");
      }
      this.allCoverSites = await getGCSites();
      print(this.allCoverSites);
      dataLoaded = true;
      print("Data loaded");

      List<dynamic> baseCoverSiteList = allCoverSites.where((s) => s.GCname == baseCoverSiteKey).toList();
      baseCoverSite = baseCoverSiteList[0];
      baseCoverSamples = baseCoverSite.GCsamples;
      reverseBaseCoverSamples = baseCoverSamples.reversed.toList();
      print("baseCoverSamples");
      print(baseCoverSamples);
      setState(() {});
    }
    if (!dataLoaded){
      print("trying to load");
      loadData();
    }


    Future<void> deleteSamples() async {
      overrideGCSite(iSite);
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
                Navigator.of(context).pop(GroundCoverSampleList());
              },
            ),
            MaterialButton(
              child: Text('Confirm'),
              onPressed: () {
                print(baseCoverSamples);
                deleteSamples();
                Navigator.of(context).pop(GroundCoverSampleList());
              },
            ),
          ],
        );
      });
    }


    return Container(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Ground Cover Sample List'),
            actions: <Widget>[
              IconButton(onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
              },
                  icon: Icon(Icons.home)),
              IconButton(onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Credits()),
                );
              },
                  icon: Icon(Icons.more_vert)),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListView.builder(
                reverse: true,
                itemCount: reverseBaseCoverSamples.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.lightGreenAccent,
                          border: Border.all(color: Colors.lightGreen, width: 3),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: ListTile(title: Text('Species: ' + reverseBaseCoverSamples[index].speciesList),

                        leading: Icon(Icons.arrow_forward_ios),
                        subtitle: Text(
                            reverseBaseCoverSamples[index].lat.toString() + ', ' +
                                reverseBaseCoverSamples[index].lon.toString() +', ' +
                                'Cover: ' + reverseBaseCoverSamples[index].coverPercentage.toString() +'%, ' +
                                'Height: ' + reverseBaseCoverSamples[index].coverHeight.toString() +'cm, ' +
                                'Weeds: ' + reverseBaseCoverSamples[index].weedsRatio.toString()+'%, '
                        ),
                      ),
                    ),
                  );

                }
            ),
          ),
          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton.icon(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddGroundCoverSample()),
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
                  // print("Export Data");
                  // sendEmail(baseCoverSite);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => Credits()),
                  // );

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
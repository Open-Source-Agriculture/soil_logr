import 'package:soil_mate/services/app_hive.dart';
import 'dart:async';
import '../GC_models/GC_common_keys.dart';
import '../GC_models/GC_site.dart';



Future<List<GCSite>> getGCSites() async {
  List<GCSite> sites = [];
  await appBoxes.load();
  if (appBoxes.isLoaded){
    if (appBoxes.siteBox.isNotEmpty){
      print(appBoxes.siteBox.length);
//      print(appBoxes.siteBox.values);
      print(appBoxes.siteBox.keys);
      sites  = appBoxes.siteBox.keys.toList().map((e) => GCSite(
        GCname: appBoxes.siteBox.get(e)[SITE_NAME],
        rawGCSamples: appBoxes.siteBox.get(e)[GC_SAMPLES].toList(),
        GCincrement: appBoxes.siteBox.get(e)[GC_INCREMENT],
      )).toList();

    }
  }else{
    print("False");
  }
  return sites;
}

Future<bool> saveGCSite(GCSite gcsite) async {
  bool siteExists = false;
  await appBoxes.load();
  if (appBoxes.isLoaded){
    Map<String, dynamic> siteMap = {
      SITE_NAME: gcsite.GCname,
      GC_DATE: gcsite.date,

    };
//    print(siteMap.toString());
    if (!appBoxes.siteBox.containsKey(gcsite.GCname)){
      appBoxes.queSiteBox.put(gcsite.GCname,siteMap);
      appBoxes.siteBox.put(gcsite.GCname, siteMap);
    }else{
      siteExists = true;
    }
  }
  return siteExists;
}

Future<bool> overrideGCSite(GCSite gcsite) async {
  bool siteExists = false;
  await appBoxes.load();
  if (appBoxes.isLoaded){
    Map<String, dynamic> siteMap = {
      SITE_NAME: gcsite.GCname,
      GC_DATE: gcsite.date,
      GC_SAMPLES: gcsite.GCsamples.map((s) => s.getGCData()).toList(),
      GC_INCREMENT :gcsite.GCincrement,

    };
    appBoxes.queSiteBox.put(gcsite.GCname,siteMap);
    appBoxes.siteBox.put(gcsite.GCname, siteMap);
  }
  return siteExists;
}
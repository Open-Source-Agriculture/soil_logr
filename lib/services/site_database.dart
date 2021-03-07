import 'package:soil_mate/services/app_hive.dart';
import 'package:soil_mate/models/site.dart';
import 'package:soil_mate/models/common_keys.dart';
import 'dart:async';



Future<List<Site>> getSites() async {
  List<Site> sites = [];
  await appBoxes.load();
  if (appBoxes.isLoaded){
    if (appBoxes.siteBox.isNotEmpty){
      print(appBoxes.siteBox.length);
//      print(appBoxes.siteBox.values);
      print(appBoxes.siteBox.keys);
      sites  = appBoxes.siteBox.keys.toList().map((e) => Site(
          name: appBoxes.siteBox.get(e)[SITE_NAME],
          classification: appBoxes.siteBox.get(e)[TEXTURE_CLACIFICATION],
          rawSamples: appBoxes.siteBox.get(e)[SAMPLES].toList(),
          increment: appBoxes.siteBox.get(e)[INCREMENT],
      )).toList();

    }
  }else{
    print("False");
  }
  return sites;
}

Future<bool> saveSite(Site site) async {
  bool siteExists = false;
  await appBoxes.load();
//  print(site.name);
//  print(site.classification);
//  print(site.date);
//  print(site.samples.map((s) => s.getData()).toList());
  if (appBoxes.isLoaded){
    Map<String, dynamic> siteMap = {
      SITE_NAME: site.name,
      TEXTURE_CLACIFICATION: site.classification,
      DATE: site.date,
      SAMPLES: site.samples.map((s) => s.getData()).toList(),
      INCREMENT :site.increment,
    };
//    print(siteMap.toString());
    if (!appBoxes.siteBox.containsKey(site.name)){
      appBoxes.queSiteBox.put(site.name,siteMap);
      appBoxes.siteBox.put(site.name, siteMap);
    }else{
      siteExists = true;
    }
  }
  return siteExists;
}

Future<bool> overrideSite(Site site) async {
  bool siteExists = false;
  await appBoxes.load();
//  print(site.name);
//  print(site.classification);
//  print(site.date);
//  print(site.samples.map((s) => s.getData()).toList());
  if (appBoxes.isLoaded){
    Map<String, dynamic> siteMap = {
      SITE_NAME: site.name,
      TEXTURE_CLACIFICATION: site.classification,
      DATE: site.date,
      SAMPLES: site.samples.map((s) => s.getData()).toList(),
      INCREMENT :site.increment,

    };
//    print(siteMap.toString());
    await appBoxes.queSiteBox.put(site.name,siteMap);
    await appBoxes.siteBox.put(site.name, siteMap);
  }
  return siteExists;
}
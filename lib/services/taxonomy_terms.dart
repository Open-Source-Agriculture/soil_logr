import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;



Future<Map> loadTaxonomyMap(String taxonomy) async {
  String data = await rootBundle.loadString("assets/farmOS/taxonomy_term.json");
  final jsonResult = json.decode(data);
  List taxonomyTerms =  jsonResult["list"];
  Map taxonomyMap = {};
  taxonomyTerms.forEach((element) {
    taxonomyMap[element["name"]] = element;
  });

  int soilSampleTID = int.parse(taxonomyMap[taxonomy]["tid"].toString());


  bool checkIfParent(int pid, List parents){
    bool isParent = false;
    parents.forEach((element) {
      if (element["id"].toString() == pid.toString()){
        isParent = true;
      }
    }
    );
    return(isParent);
  }

  Map filteredTaxonomyMap = {};
  taxonomyMap.forEach((key, value) {
    if (checkIfParent(soilSampleTID, value["parents_all"]) & (value["tid"].toString() != soilSampleTID.toString())){
      filteredTaxonomyMap[key] = value;
    };
  });
//                  filteredTaxonomyMap.forEach((key, value) {print(value["name"]);});

  return(filteredTaxonomyMap);
}
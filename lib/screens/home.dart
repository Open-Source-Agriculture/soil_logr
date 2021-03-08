
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:soil_mate/models/taxonomy_term.dart';
import 'package:soil_mate/services/navigation_bloc.dart';
import 'package:soil_mate/screens/credits.dart';
import 'package:soil_mate/services/sizes_and_themes.dart';
import 'package:soil_mate/services/taxonomy_terms.dart';

class Home extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "HomePage",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
          ),
//          RaisedButton(
//            child: Text("Test JSON"),
//              onPressed: (){
//              final taxonomyTermBox = Hive.box("taxonomy_term");
//              List tKeys = taxonomyTermBox.keys.toList();
//              print("------------------------");
//              tKeys.forEach((element) {
//                final TaxonomyTerm taxTerm = taxonomyTermBox.get(element) as TaxonomyTerm;
//                print(taxTerm.name);
//              });
//
//              }
//          )
        ],
      ),
    );
  }
}
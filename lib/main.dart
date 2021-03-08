import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:soil_mate/screens/sample_list.dart';
import 'package:soil_mate/screens/side_bar/sidebar_layout.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:soil_mate/services/taxonomy_terms.dart';

import 'models/taxonomy_term.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(TaxonomyTermAdapter());
  runApp(MyApp());


}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.white
      ),
      home: FutureBuilder(
        future: Hive.openBox('taxonomy_term'),
        builder: (BuildContext context, AsyncSnapshot snapshot){

          void injectTaxonomyTerm(String tKey, TaxonomyTerm taxonomyTerm) {
            final taxonomyTermBox = Hive.box('taxonomy_term');
            taxonomyTermBox.put(tKey, taxonomyTerm);
          }

          Future injectTaxonomyTerms() async {
            Map terms = await loadTaxonomyMap("soil_sample");
            terms.forEach((key, value) {
              TaxonomyTerm taxTerm = TaxonomyTerm(tid: int.parse(value["tid"]), name: value["name"], description: value["description"], parent: value["parent"], parents_all: value["parents_all"]);
              injectTaxonomyTerm(key, taxTerm);
            });

          }
//          final taxonomyTermBox = Hive.box('taxonomy_term');
//          taxonomyTermBox.clear();

          injectTaxonomyTerms();




          if (snapshot.connectionState == ConnectionState.done){
            if (snapshot.hasError){
              return Text(snapshot.error.toString());
            }else{
              return SideBarLayout();
            }
          }else{
            return Scaffold();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
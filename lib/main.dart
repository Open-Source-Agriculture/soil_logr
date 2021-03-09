import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:soil_mate/ground_cover/GC_screens/GC_result.dart';
import 'package:soil_mate/screens/credits.dart';
import 'package:soil_mate/screens/home.dart';
import 'package:soil_mate/screens/sample_list.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:soil_mate/services/taxonomy_terms.dart';

import 'models/log.dart';
import 'models/taxonomy_term.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(TaxonomyTermAdapter());
  Hive.registerAdapter(LogAdapter());
  Hive.registerAdapter(QuantityAdapter());
  Hive.registerAdapter(GeoFieldAdapter());

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
            Map ausTerms = await loadTaxonomyMap("aus_classification");
            ausTerms.forEach((key, value) {
              TaxonomyTerm taxTerm = TaxonomyTerm(tid: int.parse(value["tid"]), name: value["name"], description: value["description"], parent: value["parent"], parents_all: value["parents_all"]);
              injectTaxonomyTerm(key, taxTerm);
            });

            Map gcTerms = await loadTaxonomyMap("ground_cover");
            gcTerms.forEach((key, value) {
              TaxonomyTerm taxTerm = TaxonomyTerm(tid: int.parse(value["tid"]), name: value["name"], description: value["description"], parent: value["parent"], parents_all: value["parents_all"]);
              injectTaxonomyTerm(key, taxTerm);
            });

          }
//          final taxonomyTermBox = Hive.box('taxonomy_term');
//          taxonomyTermBox.clear();




          if (snapshot.connectionState == ConnectionState.done){
            injectTaxonomyTerms();
            if (snapshot.hasError){
              return Text(snapshot.error.toString());
            }else{
              return Home();//SideBarLayout();
            }
          }else{
            return Scaffold();
          }
        },
      ),
      initialRoute: '/',
      routes: {
        '/ground_cover_survey': (context) => GroundCoverResult(),
        '/credits': (context) => Credits(),
        '/texture_survey': (context) => SampleList(),
      },
    );
  }

//  @override
//  void dispose() {
//    Hive.close();
//    super.dispose();
//  }

}
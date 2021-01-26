
import 'package:soil_mate/models/sample.dart';
import 'package:soil_mate/models/common_keys.dart';

class Site{
  final DateTime date = DateTime.now();
  String name;
  String classification;
  List rawSamples;
  List<Sample> samples = [];
  var defaultList;
  int increment;
//  Incrementer incrementer = Incrementer();



  Site({this.name, this.classification, this.rawSamples, this.increment}){
//    this.name = name;
//    this.classification = classification;// e[TEXTURE_CLACIFICATION];
//    this.rawSamples = rawSamples;// e[SAMPLES].toList();
//    print("rawSamples");
//    print(this.rawSamples);
    this.rawSamples = this.rawSamples.map((rawSample) => rawSample).toList();
    List<Sample> mysamples = this.rawSamples.map((e) => Sample(
      lat: e[LAT],
      lon: e[LON],
      textureClass: e[TEXTURECLASS],
      depthShallow: e[DEPTHSHALLOW],
      depthDeep: e[DEPTHDEEP],
      sand: e[SAND],
      silt: e[SILT],
      clay: e[CLAY],
      id: e[ID],

    )).toList();
    samples = mysamples;
  }

  void addSample(Sample sample){
    samples.add(sample);
  }
}
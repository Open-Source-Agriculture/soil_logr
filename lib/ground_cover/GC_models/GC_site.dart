import 'GC_common_keys.dart';
import 'GC_sample.dart';


class GCSite{
  final DateTime date = DateTime.now();
  String GCname;
  List rawGCSamples;
  List<GCSample> GCsamples = [];
  var defaultGCList;
  int GCincrement;
//  Incrementer incrementer = Incrementer();



  GCSite({this.GCname, this.rawGCSamples, this.GCincrement}){
    this.rawGCSamples = this.rawGCSamples.map((rawGCSamples) => rawGCSamples).toList();
    List<GCSample> myGCsamples = this.rawGCSamples.map((e) => GCSample(
      lat: e[LAT],
      lon: e[LON],
      gcId: e[GC_ID],
      coverHeight: e[COVER_HEIGHT],
      coverPercentage: e[COVER_PERCENTAGE],
      weedsRatio: e[WEEDS_RATIO],
      speciesList: e[SPECIES_LIST],

    )).toList();
    GCsamples = myGCsamples;
  }

  void addSample(GCSample sample){
    GCsamples.add(sample);
  }
}
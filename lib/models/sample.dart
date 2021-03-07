import 'package:soil_mate/models/common_keys.dart';

class Sample{
  final double lat;
  final double lon;
  final String textureClass;
  // nearest cm
  final int depthShallow;
  final int depthDeep;
  // nearest %
  final int sand;
  final int silt;
  final int clay;
  final int id;

  Sample({this.lat, this.lon,this.textureClass, this.depthShallow, this.depthDeep, this.sand, this.silt, this.clay, this.id});

  Map<String,dynamic> getData(){
    return {
      LAT:this.lat,
      LON:this.lon,
      TEXTURECLASS: this.textureClass,
      DEPTHSHALLOW:this.depthShallow,
      DEPTHDEEP:this.depthDeep,
      SAND:this.sand,
      SILT:this.silt,
      CLAY: this.clay,
      ID: this.id
    };
  }


}





class GeoField{
  final double lat;
  final double lon;

  GeoField({this.lat, this.lon});

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lon': lon,
    };
  }
}



class Quantity{
  final String measure;
  final double value;
  final String label;

  Quantity({this.measure, this.value, this.label});

  Map<String, dynamic> toMap() {
    return {
      'measure': measure,
      'value': value,
      'label': label
    };
  }
}


class Log{

  List<Quantity> quantity;
  int id;
  String name;
  String type; // "farm_soil_test"
  String timestamp;
  List<Map> log_category;  // from taxonomies
  String notes;
  GeoField geofield; // with keys lat lon

//  int depthShallow;
//  int depthDeep;
//  // nearest %
//  int sand;
//  int silt;
//  int clay;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      "geofield": geofield.toMap(),
      "quantity": quantity.map((e) => e.toMap()),

      // TODO fill out these
    };
  }



}
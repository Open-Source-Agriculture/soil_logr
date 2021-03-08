



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


}
import 'package:hive/hive.dart';


part 'log.g.dart';

@HiveType(typeId: 1)
class GeoField{
  @HiveField(0)
  final double lat;
  @HiveField(1)
  final double lon;

  GeoField({this.lat, this.lon});


}


@HiveType(typeId: 2)
class Quantity{
  @HiveField(0)
  final String measure;
  @HiveField(1)
  final double value;
  @HiveField(2)
  final String label;

  Quantity({this.measure, this.value, this.label});

}

@HiveType(typeId: 3)
class Log{

  @HiveField(0)
  List<Quantity> quantity;
  @HiveField(1)
  int id;
  @HiveField(2)
  String name;
  @HiveField(3)
  String type; // "farm_soil_test"
  @HiveField(4)
  String timestamp;
  @HiveField(5)
  List<Map> log_category;  // from taxonomies
  @HiveField(6)
  String notes;
  @HiveField(7)
  GeoField geofield; // with keys lat lon

//  int depthShallow;
//  int depthDeep;
//  // nearest %
//  int sand;
//  int silt;
//  int clay;


}
import 'package:hive/hive.dart';
import 'package:soil_mate/models/taxonomy_term.dart';


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
  final TaxonomyTerm units;
  @HiveField(3)
  final String label;

  Quantity({this.measure, this.value, this.units, this.label});

}

@HiveType(typeId: 3)
class Log{
  @HiveField(1)
  int id;
  @HiveField(2)
  String name;
  @HiveField(3)
  String type; // "farm_soil_test"
  @HiveField(4)
  String timestamp;  // from taxonomies
  @HiveField(5)
  String notes;
  @HiveField(6)
  GeoField geofield;
  @HiveField(7)
  List<TaxonomyTerm> log_category;
  @HiveField(8)
  List<Quantity> quantity;// with keys lat lon

  Log({this.id, this.name, this.type, this.timestamp, this.notes, this.geofield, this.log_category, this.quantity});


}
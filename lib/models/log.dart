import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soil_mate/models/taxonomy_term.dart';


part 'log.g.dart';


@HiveType(typeId: 1)
class GeoField{
  @HiveField(0)
  final double lat;
  @HiveField(1)
  final double lon;

  GeoField({this.lat, this.lon});


  Map<String, double> toMap(){
    return({
      "lat": lat,
      "lon": lon,
    });
  }

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

  Map<String, dynamic> toMap(){
    return({
      "measure": measure,
      "value": value,
      "units": units.toMap(),
      "label": label
    });
  }
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
  @HiveField(9)
  List<String> images;


  Log({this.id, this.name, this.type, this.timestamp, this.notes, this.geofield, this.log_category, this.quantity, this.images});


  Map<String, dynamic> toMap(){
    return({
      "id": id,
      "name": name,
      "type": type,
      "timestamp": timestamp,
      "notes": notes,
      "geofield": geofield.toMap(),
      "images": images,
      "log_category": log_category.map((t) => t.toMap()),
      "quantity": quantity.map((e) => e.toMap()),
    });
  }


}
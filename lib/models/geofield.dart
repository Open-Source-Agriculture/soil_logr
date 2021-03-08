import 'package:hive/hive.dart';


part 'geofield.g.dart';

@HiveType(typeId: 1)
class GeoField{
  @HiveField(0)
  final double lat;
  @HiveField(1)
  final double lon;

  GeoField({this.lat, this.lon});


}

import 'package:hive/hive.dart';
import 'package:soil_mate/models/taxonomy_term.dart';


part 'quantity.g.dart';

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
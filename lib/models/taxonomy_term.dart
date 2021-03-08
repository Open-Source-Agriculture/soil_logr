import 'package:hive/hive.dart';

part 'taxonomy_term.g.dart';

@HiveType(typeId: 0)
class TaxonomyTerm {
  @HiveField(0)
  final int tid;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final List<dynamic> parent; // TODO type these
  @HiveField(4)
  final List<dynamic> parents_all; // TODO type these

//  @HiveField(5)
//  final String url;
//  @HiveField(6)
//  final int node_count;
//  @HiveField(7)
//  final int weight;
//  @HiveField(8)
//  final List<Map<String, dynamic>> vocabulary;

  TaxonomyTerm({this.tid, this.name, this.description, this.parent, this.parents_all});


  Map<String, dynamic> toMap(){
    return({
      "tid": tid,
      "name": name,
      "description": description,
      "parent": parent,
      "parents_all": parents_all
    });
  }

}
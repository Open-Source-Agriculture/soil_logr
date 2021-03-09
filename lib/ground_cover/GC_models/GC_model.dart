import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';

class GroundCoverModel {
  double lat;
  double lon;

  int gcId;

  // ground cover
  double coverHeight;
  double coverPercentage;
  double weedsRatio;
  Map<String, int> speciesMap;
  final int totalSpeciesCount;
  final String name;
  final String key;

  PickedFile imageFile;

  GroundCoverModel({this.totalSpeciesCount, this.name, this.key, this.imageFile, lat, this.lon, this.gcId, this.coverHeight, this.coverPercentage, this.weedsRatio, this.speciesMap});
}


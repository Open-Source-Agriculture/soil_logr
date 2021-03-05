import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GroundCoverModel {
  double lat;
  double lon;

  int gcId;

  // ground cover
  double coverHeight;
  double coverPercentage;
  double weedsRatio;
  String speciesList;
  PickedFile imageFile;

  GroundCoverModel({this.imageFile, lat, this.lon, this.gcId, this.coverHeight, this.coverPercentage, this.weedsRatio, this.speciesList});
}
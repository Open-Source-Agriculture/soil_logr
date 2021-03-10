
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


  GroundCoverModel({this.totalSpeciesCount, this.name, this.key, lat, this.lon, this.gcId, this.coverHeight, this.coverPercentage, this.weedsRatio, this.speciesMap});
}


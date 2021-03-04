import 'GC_common_keys.dart';

class GCSample{
  final double lat;
  final double lon;

  final int gcId;

  // ground cover
  final double coverHeight;
  final double coverPercentage;
  final double weedsRatio;
  final String speciesList;

  GCSample({this.gcId, this.coverHeight, this.coverPercentage, this.weedsRatio, this.speciesList, this.lat, this.lon});

  Map<String,dynamic> getGCData(){
    return {
      LAT:this.lat,
      LON:this.lon,
      GC_ID: this.gcId,
      COVER_HEIGHT: this.coverHeight,
      COVER_PERCENTAGE: this.coverPercentage,
      WEEDS_RATIO: this.weedsRatio,
      SPECIES_LIST: this.speciesList,
    };
  }


}
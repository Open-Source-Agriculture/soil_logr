import 'package:soil_mate/models/common_keys.dart';

class Sample{
  final double lat;
  final double lon;
  final String textureClass;
  // nearest cm
  final int depthShallow;
  final int depthDeep;
  // nearest %
  final int sand;
  final int silt;
  final int clay;
  final int id;

  Sample({this.lat, this.lon,this.textureClass, this.depthShallow, this.depthDeep, this.sand, this.silt, this.clay, this.id});

  Map<String,dynamic> getData(){
    return {
      LAT:this.lat,
      LON:this.lon,
      TEXTURECLASS: this.textureClass,
      DEPTHSHALLOW:this.depthShallow,
      DEPTHDEEP:this.depthDeep,
      SAND:this.sand,
      SILT:this.silt,
      CLAY: this.clay,
      ID: this.id
    };
  }


}
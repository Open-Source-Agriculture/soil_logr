import 'package:flutter/cupertino.dart';

class AusClassification {
  TextureClass sandyLoam = TextureClass(name: 'Sandy Loam', sand: 65, silt: 23, clay: 12);
  TextureClass loam = TextureClass(name: 'Loam',sand: 40, silt: 40, clay: 20);
  TextureClass sandyClay = TextureClass(name: 'Sandy Clay',sand: 50, silt: 10, clay: 40);
  TextureClass clay = TextureClass(name: 'Clay',sand: 20, silt: 20, clay: 60);
  TextureClass siltyClay = TextureClass(name: 'Silty Clay',sand: 5, silt: 50, clay: 45);
  TextureClass siltyLoam = TextureClass(name: 'Silty Loam',sand: 20, silt: 65, clay: 15);
  TextureClass siltyClayLoam = TextureClass(name: 'Silty Clay Loam',sand: 10, silt: 55, clay: 35);
  TextureClass silt = TextureClass(name: 'Silt',sand: 5, silt: 87, clay: 8);
  TextureClass clayLoam = TextureClass(name: 'Clay Loam',sand: 34, silt: 33, clay: 33);
  TextureClass sandyClayLoam = TextureClass(name: 'Sandy Clay Loam',sand: 60, silt: 13, clay: 27);
  TextureClass loamySand = TextureClass(name: 'Loamy Sand',sand: 82, silt: 10, clay: 8);
  TextureClass sand = TextureClass(name: 'Sand',sand: 95, silt: 3, clay: 2);

  List<TextureClass> getTextureList(){
    return  [sand, loamySand, sandyLoam, sandyClayLoam, sandyClay, loam, clayLoam, siltyLoam, silt, siltyClayLoam, siltyClay, clay];
  }

}

class TextureClass{
  final int sand;
  final int silt;
  final int clay;
  final String name;
  Color getColor() {
    int R = (225*sand + 225*clay)~/100;
    int G = (225*sand + 225*silt)~/100;
    int B = (225*silt + 225*clay)~/100;
    return Color.fromRGBO(R, G, B, 1);
  }
  TextureClass({this.name, this.sand,this.silt,this.clay});
}

import 'package:flutter/material.dart';
import 'package:soil_mate/models/texture_models.dart';
import '../services/sizes_helper.dart';

class TextureButton extends StatelessWidget {
  final TextureClass textureClass;
  final Function setTextureFunction;

  TextureButton({
    Key /*?*/ key,
    @required this.textureClass,
    @required this.setTextureFunction,
  }) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: FlatButton(
        padding: EdgeInsets.all(0),
        color: textureClass.getColor().withOpacity(0.5),
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: textureClass.getColor(),
                width: 2,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(15)),
        onPressed: () {
          print(this.textureClass.name);
          this.setTextureFunction(this.textureClass);
        },
        child: Text(
          textureClass.name,
          style: TextStyle(
            fontSize: displayWidth(context) * 0.035,
          ),
        ),
      ),
    );
  }
}
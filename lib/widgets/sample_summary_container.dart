import 'package:flutter/material.dart';
import 'package:soil_mate/models/texture_models.dart';
import '../services/sizes_and_themes.dart';

class SampleSummary extends StatelessWidget {
  final TextureClass selectedTexture;
  final int depthUpper;
  final int depthLower;
  final int sampleID;
  // Site site = Site(
  //     name: 'placeHolder', classification: "aus", rawSamples: [], increment: 0);

  SampleSummary({
    Key /*?*/ key,
    @required this.selectedTexture,
    @required this.depthLower,
    @required this.depthUpper,
    @required this.sampleID,
  }) : super(key: key) {}


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(displayWidth(context) * 0.03),
      decoration: BoxDecoration(
        color: selectedTexture.getColor().withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: selectedTexture.getColor(),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Summary',
            style: headingTextStyle(context),
          ),
          Text(
            'Texture:  ' +
                selectedTexture.name +
                '\nDepth:  ' +
                depthUpper.toString() +
                ' cm to ' +
                depthLower.toString() +
                ' cm' +
                '\nSample ID:  ' +
                sampleID.toString(),
            style: bodyTextStyle(context),
          ),
        ],
      ),
    );
  }
}
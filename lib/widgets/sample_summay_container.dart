import 'package:flutter/material.dart';
import 'package:soil_mate/models/site.dart';
import 'package:soil_mate/models/texture_models.dart';

// NOTE: currently this doesn't work properly so I am commenting it out for now.

TextureClass selectedTexture = AusClassification().getTextureList()[0];
int depthUpper = 0;
int depthLower = 10;
Site site = Site(
    name: 'placeHolder', classification: "aus", rawSamples: [], increment: 0);

// Center SampleSummary() {
//   return Center(
//     child: Container(
//       width: 250,
//       padding: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: selectedTexture.getColor().withOpacity(0.5),
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(
//           color: selectedTexture.getColor(),
//           width: 2,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Text(
//             'Sample Summary',
//             style: TextStyle(
//               fontSize: 20,
//             ),
//           ),
//           Text(
//             'Texture:  ' +
//                 selectedTexture.name +
//                 '\nDepth range:  ' +
//                 depthUpper.toString() +
//                 ' cm to ' +
//                 depthLower.toString() +
//                 ' cm' +
//                 '\nSample ID:  ' +
//                 site.increment.toString(),
//             style: TextStyle(),
//           ),
//         ],
//       ),
//     ),
//   );
// }
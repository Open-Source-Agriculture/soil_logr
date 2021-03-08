import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_mailer/flutter_mailer.dart';


Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}


Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/Soil_Mate_' + DateTime.now().toIso8601String() + '.csv');
}


Future<String> writeCSV(String csvString) async {
  final file = await _localFile;
  file.writeAsString(csvString);
  return file.path;
}





Future<void> createEmailWithCSV(String csvContents) async {
  String path = await writeCSV(csvContents);
  print(path);

  final MailOptions mailOptions = MailOptions(
    body: 'See attached the texture samples',
    subject: 'Texture samples',
//    recipients: ['example@example.com'],
//    isHTML: true,
//    bccRecipients: ['other@example.com'],
//    ccRecipients: ['third@example.com'],
    attachments: [path, ],
  );

  final MailerResponse response = await FlutterMailer.send(mailOptions);
  print(response);

//  switch (response) {
//    case MailerResponse.saved: /// ios only
//      platformResponse = 'mail was saved to draft';
//      break;
//    case MailerResponse.sent: /// ios only
//      platformResponse = 'mail was sent';
//      break;
//    case MailerResponse.cancelled: /// ios only
//      platformResponse = 'mail was cancelled';
//      break;
//    case MailerResponse.android:
//      platformResponse = 'intent was successful';
//      break;
//    default:
//      platformResponse = 'unknown';
//      break;
  }


//void sendEmail(Site site){
//  print("make csv");
//  List<Sample> samples = site.samples;
//  List<List<String>> allSamplesLists = samples.map((s) {
//                    List<String> sampleList = [
//                      s.id.toString(),
//                      s.lat.toString(),
//                      s.lon.toString(),
//                      s.textureClass,
//                      s.depthShallow.toString(),
//                      s.depthDeep.toString(),
//                      s.sand.toString(),
//                      s.silt.toString(),
//                      s.clay.toString()
//                    ];
//                    print(sampleList);
//                    return sampleList;
//                  }).toList();
//  List<String> headers = [ID, LAT, LON, TEXTURECLASS, DEPTHSHALLOW, DEPTHDEEP, SAND, SILT, CLAY];
//  List<List<String>> headerAllSamplesLists = [headers] + allSamplesLists;
//  String csv = const ListToCsvConverter().convert(headerAllSamplesLists);
//  createEmailWithCSV(csv);
//
//}
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:share/share.dart';
import 'package:soil_mate/models/log.dart';


Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}


Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/Soil_LogR_' + DateTime.now().toIso8601String() + '.csv');
}


Future<String> writeCSV(String csvString) async {
  final file = await _localFile;
  file.writeAsString(csvString);
  return file.path;
}



Future<void> createEmailWithCSV(String csvContents, List<String> images) async {
  String path = await writeCSV(csvContents);
  Share.shareFiles([path] + images, text: 'See attached the samples',  subject: 'Soil LogR samples');

  }


void sendEmail(List<Log> logs){
  print("make csv");

  if (logs.isNotEmpty){
    List<List<String>> allSamplesLists = [];

    List<String> headers = ["id", "Latitude", "Longitude", "Category", "Image"];

    Log firstLog = logs[0];

    firstLog.quantity.forEach((q) {
      headers.add(q.label);
    });

    List<String> attachImages = [];

    logs.forEach((l) {
      List<String> row = [
        l.id.toString(),
        l.geofield.lat.toString(),
        l.geofield.lon.toString(),
        l.log_category[0].name,
        l.images[0].split("/").last
      ];

      if (l.images[0].split("/").last != "placeholder.png"){
        attachImages.add(l.images[0]);

      }



      l.quantity.forEach((q) {
        row.add(q.value.toString());
      });

      allSamplesLists.add(row);

    });


    List<List<String>> headerAllSamplesLists = [headers] + allSamplesLists;
    String csv = const ListToCsvConverter().convert(headerAllSamplesLists);
    csv = csv.replaceAll("\r\n", "\n").replaceAll("\r", "\n").replaceAll("\n\n", "\n");
    createEmailWithCSV(csv, attachImages);
  }

}
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async';


AppBoxes appBoxes = AppBoxes();

class AppBoxes {

  bool isLoaded = false;
  Box userBox;
  Box queSiteBox;
  Box siteBox;

  AppBoxes(){
    load();
  }

  Future<Object> load() async {
    await Hive.initFlutter();
//    var dir = await getApplicationDocumentsDirectory();
//    Hive.init(dir.path);

    await Hive.openBox('siteBox');
    siteBox = Hive.box('siteBox');
//    siteBox.clear();


    await Hive.openBox('queSiteBox');
    queSiteBox = Hive.box('queSiteBox');
//    queSiteBox.clear();

    await Hive.openBox('userBox');
    userBox = Hive.box('userBox');

    isLoaded = true;

  }
}
import 'package:flutter/material.dart';
import 'package:soil_mate/screens/home/sample_list.dart';


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SampleList();
//    // This is hidden for the minimal app
//    final user = Provider.of<User>(context);
//    if (user == null){
//      return Authenticate();
//    }else{
//      return Home();
//    }
  }
}

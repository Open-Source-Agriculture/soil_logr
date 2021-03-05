import 'package:flutter/material.dart';
import 'package:soil_mate/ground_cover/GC_models/GC_model.dart';
import 'package:soil_mate/ground_cover/GC_screens/GC_form.dart';
import 'dart:io';

class GroundCoverResult extends StatefulWidget{
  GroundCoverModel model;

  GroundCoverResult({this.model});

  @override
  _GroundCoverResultState createState() => _GroundCoverResultState();
}

class _GroundCoverResultState extends State<GroundCoverResult> {
  List<GroundCoverModel> GroundCoverList = [];
  @override
  Widget build(BuildContext context) {


    return (Scaffold(
      appBar: AppBar(title: Text('Successful')),
      body: ListView.builder(
        itemCount: 1, //GroundCoverList.length,
        itemBuilder: (context, index){
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              radius: 80,
              backgroundImage: widget.model.imageFile == null ? AssetImage("assets/placeholder.png"): FileImage(File(widget.model.imageFile.path)),
            ),
              title: Text('Species List: ' + widget.model.speciesList),
            subtitle: Text( 'Cover %: ${widget.model.coverPercentage} ' + 'Cover Hiehgt: ${widget.model.coverHeight}' + 'Weeds Ratio: ${widget.model.weedsRatio}'),
          ),
        );
        }
      ),
      bottomNavigationBar: RaisedButton(
        child: Text('Add Sample'),
          onPressed: () {
            Navigator.pop(
                context,
                MaterialPageRoute(
                    builder: (context) => GroundCoverForm()));
          }
      ),
    ));
  }
}
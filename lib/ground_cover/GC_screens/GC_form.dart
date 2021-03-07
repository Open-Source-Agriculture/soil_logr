import 'dart:io';

import 'package:flutter/material.dart';
import 'package:soil_mate/ground_cover/GC_models/GC_model.dart';
import 'package:soil_mate/ground_cover/GC_screens/GC_result.dart';
import 'package:soil_mate/services/navigation_bloc.dart';
import 'package:soil_mate/services/sizes_and_themes.dart';
import 'package:image_picker/image_picker.dart';


class GroundCoverForm extends StatefulWidget with NavigationStates{

  @override
  _GroundCoverFormState createState() => _GroundCoverFormState();
}

class _GroundCoverFormState extends State<GroundCoverForm> {
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  GroundCoverModel model = GroundCoverModel();
  double coverPercentage = 0.0;
  double weedsRatio  = 0.0;
  double coverHeight = 0.0;




  Map<String, int> mySpecies = {
    'Grasses perennial': 0,
    'Grasses annual': 0,
    'Forbs perennial': 0,
    'Forbs annual': 0,
    'Legumes' : 0,
    'Native pasture' : 0,
  };


  @override
  Widget build(BuildContext context) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;





    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(height: displayHeight(context)*0.03,),
            Text('Percentage of Ground Cover'),
            Slider(
              value: coverPercentage == null ? 0.0 : coverPercentage,
              onChanged: (newCoverPercentage) {
                setState(() => coverPercentage = newCoverPercentage);
              },
              divisions: 10,
              label: '$coverPercentage %',
              min: 0,
              max: 100,
            ),
            Text('Height of Cover'),
            Slider(

              value: coverHeight== null ? 0.0 : coverHeight,
              onChanged: (newCoverHeight) {
                setState(() => coverHeight = newCoverHeight);
              },
              divisions: 10,
              label: '$coverHeight cm',
              min: 0,
              max: 100,
            ),
            Text('Percentage of Weeds from total vegetation'),
            Slider(
              value: weedsRatio== null ? 0.0 : weedsRatio,
              onChanged: (newWeeds) {
                setState(() => weedsRatio = newWeeds);
              },
              divisions: 10,
              label: '$weedsRatio %',
              min: 0,
              max: 100,
            ),


            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: mySpecies.length,
              itemBuilder: (context, index) {
                String speciesName = mySpecies.keys.toList()[index];
                int speciesCount = mySpecies[speciesName];
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(speciesName),
                      Row(
                        children: [
                          RawMaterialButton(
                            //elevation: 2.0,
                            // fillColor: Color(0xff2C9C0A),
                            // shape: CircleBorder(),
                            child: Icon(Icons.remove),
                            onPressed: () {
                              if (mySpecies[speciesName] > 0 ){
                                  mySpecies[speciesName] =
                                      mySpecies[speciesName] - 1;
                                  setState(() {});
                                }
                              },
                          ),
                          Text(speciesCount.toString()),
                          RawMaterialButton(
                            //elevation: 2.0,
                            // fillColor: Color(0xff2C9C0A),
                            // shape: CircleBorder(),
                            child: Icon(Icons.add),
                            onPressed: () {
                              mySpecies[speciesName] = mySpecies[speciesName] + 1;
                              setState(() {

                              });
                            },
                          ),
                        ],
                      ),

                    ],
                  ),
                );
              }),
            ),
            imageProfile(context),
            RaisedButton(
              color: Colors.blueAccent,
              onPressed: () {

                model.coverPercentage = coverPercentage;
                model.coverHeight = coverHeight;
                model.weedsRatio = weedsRatio;
                model.lat = 32.0;
                model.lon = 32.0;


                model.speciesMap = mySpecies;
                model.totalSpeciesCount = mySpecies.values.toList().reduce((value, element) => value+element);
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GroundCoverResult(model: this.model)));
                }
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      );
  }

  Widget imageProfile(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 80,
            backgroundImage: model.imageFile == null ? AssetImage("assets/placeholder.png"): FileImage(File(model.imageFile.path)),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: IconButton(
                onPressed: (){
                  takePhoto(ImageSource.camera);
                },
                icon: Icon(Icons.camera_alt),
              color: Colors.pink,
            ),
          ),
        ],
      ),
    );
  }

  // Widget bottomSheet(BuildContext context) {
  //   return Container(
  //     height: displayHeight(context)*0.4,
  //     width: displayWidth(context),
  //     margin: EdgeInsets.symmetric(
  //       horizontal: 20,
  //       vertical: 20,
  //     ),
  //     child:
  //   );
  // }

  void takePhoto(ImageSource source) async{
    final pickedFile = await _picker.getImage(
        source: source,
    );
    setState(() {
      model.imageFile = pickedFile;
    });
  }


}
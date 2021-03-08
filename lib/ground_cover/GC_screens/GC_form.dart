import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soil_mate/services/navigation_bloc.dart';
import 'package:soil_mate/ground_cover/GC_models/GC_model.dart';
import 'package:soil_mate/ground_cover/GC_screens/GC_result.dart';
import 'package:soil_mate/services/sizes_and_themes.dart';
import 'package:image_picker/image_picker.dart';


class GroundCoverForm extends StatefulWidget  with NavigationStates{

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
  int totalSpeciesCount = 0;
  PickedFile imageFile = PickedFile("assets/placeholder.png");





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


    sliderColor(value) {
      if (value < 30) {
        return Colors.green[200];
      } if (value < 70) {
        return Colors.green[400];
      }
      else {
        return Colors.green[700];
      }
    }


    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20,30,10,10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: displayHeight(context)*0.08,),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  color: Colors.grey[200],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 8),
                      child: Text(
                        'Percentage of Ground Cover',
                        style: bodyTextStyle(context),
                      ),
                    ),
                    Container(
                      //margin: EdgeInsets.symmetric(horizontal: 10),
                      color: Colors.white,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackShape: RoundedRectSliderTrackShape(),
                          trackHeight: 4.0,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                          overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                          tickMarkShape: RoundSliderTickMarkShape(),
                          valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                          valueIndicatorTextStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        child: Slider.adaptive(
                          value: coverPercentage == null ? 0.0 : coverPercentage,
                          onChanged: (newCoverPercentage) {
                            setState(() => coverPercentage = newCoverPercentage);
                          },
                          label: '${coverPercentage.round()} %',
                          divisions: 20,
                          min: 0,
                          max: 100,
                          activeColor: sliderColor(coverPercentage),
                          inactiveColor: sliderColor(coverPercentage),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 8),
                      child: Text('Height of Cover', style: bodyTextStyle(context),),
                    ),
                    Container(
                      //margin: EdgeInsets.symmetric(horizontal: 10),
                      color: Colors.white,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackShape: RoundedRectSliderTrackShape(),
                          trackHeight: 4.0,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                          overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                          tickMarkShape: RoundSliderTickMarkShape(),
                          valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                          valueIndicatorTextStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        child: Slider.adaptive(
                          value: coverHeight== null ? 0.0 : coverHeight,
                          onChanged: (newCoverHeight) {
                            setState(() => coverHeight = newCoverHeight);
                          },
                          label: '${coverHeight.round()} cm',
                          min: 0,
                          max: 100,
                          divisions: 20,
                          activeColor: sliderColor(coverHeight),
                          inactiveColor: sliderColor(coverHeight),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 8),
                      child: Text('Percentage of Weeds from total vegetation', style: bodyTextStyle(context),),
                    ),
                    Container(
                      //margin: EdgeInsets.symmetric(horizontal: 10),
                      color: Colors.white,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackShape: RoundedRectSliderTrackShape(),
                          trackHeight: 4.0,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                          overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                          tickMarkShape: RoundSliderTickMarkShape(),
                          valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                          valueIndicatorTextStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        child: Slider.adaptive(
                          value: weedsRatio== null ? 0.0 : weedsRatio,
                          onChanged: (newWeeds) {
                            setState(() => weedsRatio = newWeeds);
                          },
                          label: '${weedsRatio.round()} %',
                          min: 0,
                          max: 100,
                          divisions: 20,
                          activeColor: sliderColor(weedsRatio),
                          inactiveColor: sliderColor(weedsRatio),
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: mySpecies.length,
              itemBuilder: (context, index) {
                String speciesName = mySpecies.keys.toList()[index];
                int speciesCount = mySpecies[speciesName];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    //color: Colors.grey[200],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(speciesName, style: bodyTextStyle(context),),
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
                          Text(speciesCount.toString(), style: bodyTextStyle(context),),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  imageProfile(context),
                  RaisedButton(
                    color: Colors.blueAccent,
                    onPressed: () {
                      print(mySpecies.length);
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
                  ),
                ],
              )
            ],
          ),
        ),
      );
  }

  Widget imageProfile(BuildContext context) {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 27,
          backgroundImage: model.imageFile == null ? AssetImage("assets/placeholder.png"): FileImage(File(model.imageFile.path)),
        ),
        IconButton(
            onPressed: (){
              takePhoto(ImageSource.camera);
            },
            icon: Icon(Icons.camera_alt),
          iconSize: 40,
          color: Colors.pink,
        ),
      ],
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



class MyTextFormField extends StatelessWidget {
  final String hintText;
  final Function validator;
  final Function onSaved;
  final bool isPassword;
  final bool isEmail;

  MyTextFormField({
    this.hintText,
    this.validator,
    this.onSaved,
    this.isPassword = false,
    this.isEmail = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.all(15.0),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey[200],
        ),
        obscureText: isPassword ? true : false,
        validator: validator,
        onSaved: onSaved,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      ),
    );
  }




}


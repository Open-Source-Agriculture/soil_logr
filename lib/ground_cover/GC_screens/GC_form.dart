import 'dart:io';

import 'package:flutter/material.dart';
import 'package:validators/validators.dart' as validator;
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

  @override
  Widget build(BuildContext context) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;

    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Percentage of Ground Cover'),
            Slider(
              value: model.coverPercentage == null ? 0.0 : model.coverPercentage,
              onChanged: (newCoverPercentage) {
                setState(() => model.coverPercentage = newCoverPercentage);
              },
              divisions: 10,
              label: '$model.coverPercentage %',
              min: 0,
              max: 100,
            ),
            Text('Height of Cover'),
            Slider(

              value: model.coverHeight== null ? 0.0 : model.coverHeight,
              onChanged: (newCoverHeight) {
                setState(() => model.coverHeight = newCoverHeight);
              },
              divisions: 10,
              label: '$model.coverHeight cm',
              min: 0,
              max: 100,
            ),
            Text('Percentage of Weeds from total vegetation'),
            Slider(
              value: model.weedsRatio== null ? 0.0 : model.weedsRatio,
              onChanged: (newWeeds) {
                setState(() => model.weedsRatio = newWeeds);
              },
              divisions: 10,
              label: '$model.weedsRatio %',
              min: 0,
              max: 100,
            ),
            Text("List of species (separate by ',')"),
            MyTextFormField(
              hintText: 'Species',
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Enter plant species observed';
                }
                return null;
              },
              onSaved: (String value) {
                model.speciesList = value;
              },
            ),
            imageProfile(context),
            RaisedButton(
              color: Colors.blueAccent,
              onPressed: () {
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
  //     height: 100,
  //     width: displayWidth(context),
  //     margin: EdgeInsets.symmetric(
  //       horizontal: 20,
  //       vertical: 20,
  //     ),
  //     child: Column(
  //       children: <Widget>[
  //         Text(
  //           'Choose Photo',
  //           style: TextStyle(
  //             fontSize: 20,
  //           ),
  //         ),
  //         SizedBox(height: 20,),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //           FlatButton.icon(
  //               onPressed: (){
  //                 takePhoto(ImageSource.camera);
  //               },
  //               icon: Icon(Icons.camera),
  //               label: Text('Camera')
  //           ),
  //           // FlatButton.icon(
  //           //     onPressed: (){
  //           //       takePhoto(ImageSource.gallery);
  //           //     },
  //           //     icon: Icon(Icons.image),
  //           //     label: Text('Gallery')
  //           // ),
  //         ],
  //         ),
  //       ],
  //     ),
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


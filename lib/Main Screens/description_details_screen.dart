import 'package:activity_tracker/Model/tracker_description.dart';
import 'package:flutter/material.dart';
import 'package:activity_tracker/utils/data_helper_class.dart';
import 'package:intl/intl.dart';

class DescriptionScreen extends StatelessWidget {
  //const DescriptionScreen({Key key}) : super(key: key);

  final _formkey = GlobalKey<FormState>();
  String title ;
  String description ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Description Screen")),
      body: Center(
        child: Form(
          key: _formkey,
            child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Enter Title"),
            TextFormField(
              onChanged: (value) => this.title = value,
              validator: (value) => value.isEmpty ? "Enter Title" : null,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      //borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Enter Title"),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text("Enter Description"),
            TextFormField(
              maxLines: 3,
              validator: (value) => value.isEmpty ? "Enter Description" : null,
              onChanged: (value) => this.description = value,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Enter Description"),
            )
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(_formkey.currentState.validate()){
            String date = DateFormat("dd-MM-yyyy").format(DateTime.now());
            TrackerDescription trackerDescription = TrackerDescription(description: this.description,title: this.title,date: date,isTaskComplete: 0);
             
            var result  = DatabaseHelper.db.insert(trackerDescription);
            
            Navigator.pop(context,trackerDescription);
          }
        },
      ),
    );
  }
}

import 'package:activity_tracker/Main%20Screens/progress_report.dart';
import 'package:activity_tracker/Model/tracker_description.dart';
import 'package:activity_tracker/utils/data_helper_class.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class EditDescription extends StatefulWidget {
  final EntryDetails entryDetails;
  final int index ;
  EditDescription({Key key, @required this.entryDetails,@required this.index})
      : super(key: key);

  @override
  _EditDescriptionState createState() => _EditDescriptionState();
}

class _EditDescriptionState extends State<EditDescription> {
  bool readOnlyValue = true;
  bool colorBlue = true ;
  String changeTitle ;
  String changeDescription ;
  PageController _myPage = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("View Report")),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _myPage,
          children: <Widget>[
            page0(),
            ProgressScreen(trackerDescription: widget.entryDetails,)
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              readOnlyValue = !(readOnlyValue);
              setIcon(); 

              /*if(readOnlyValue){
                print("Description : $changeDescription");
                print("Title : $changeTitle");
                TrackerDescription trackerDescription = TrackerDescription(description: changeDescription,title: changeTitle);
                var result = DatabaseHelper.db.update(trackerDescription, widget.index);
                
                setState(() {
                  
                });
              }*/
            });
          },
          child: setIcon(),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              iconSize: 40.0,
              color: colorBlue ? Colors.blue : null,
              onPressed: (){
                setState(() {
                  _myPage.jumpToPage(0);
                  colorBlue = true ;
                });
              }),
            IconButton(
              iconSize: 40.0,
              color: colorBlue ? null : Colors.blue ,
              icon: Icon(Icons.calendar_today), 
              onPressed: (){
                setState(() {
                  _myPage.jumpToPage(1);
                  colorBlue = false ;
                  
                });
              }),
            
          ]),
        ));
  }

  Icon setIcon() {
    if (readOnlyValue) {
      return Icon(Icons.edit);
    }

    return Icon(Icons.done);
  }

  Widget page0(){
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Title"),
              TextFormField(
                onChanged: (value) => this.changeTitle = value == null ? "${widget.entryDetails.title}":value,
                readOnly: readOnlyValue,
                initialValue: "${widget.entryDetails.title}",
                decoration: InputDecoration(
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text("Description"),
              TextFormField(
                onChanged: (value) => this.changeDescription = value.isEmpty ? "${widget.entryDetails.description}" : value,
                readOnly: readOnlyValue,
                initialValue: "${widget.entryDetails.description}",
                maxLines: 3,
                decoration: InputDecoration(
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              )
            ],
          );
  }


}

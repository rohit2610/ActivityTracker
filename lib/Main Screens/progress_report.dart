import 'package:activity_tracker/Model/tracker_description.dart';
import 'package:activity_tracker/utils/data_helper_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProgressScreen extends StatefulWidget {
  final EntryDetails trackerDescription;
  ProgressScreen({Key key, @required this.trackerDescription})
      : super(key: key);

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<DateClass> dateArray = new List();
  int trueCount = 0;

  @override
  void initState() {
    super.initState();
    getDates();
  }

  getDates() async {
    var result = await DatabaseHelper.db.getDates(widget.trackerDescription);
    setState(() {
      dateArray = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: dateArray.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                onTap: () {
                  showDialogBox(context, index);
                },
                child: Dismissible(
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    setState(() {
                      if (direction == DismissDirection.startToEnd)
                        DatabaseHelper.db.removeDate(widget.trackerDescription,
                            dateArray[index].currentDate);
                      dateArray.removeAt(index);
                    });
                  },
                  key: UniqueKey(),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      color: dateArray[index].isWorkCompleted == 1
                          ? Colors.green
                          : Colors.red,
                      child:
                          ListTile(title: Text(dateArray[index].currentDate)),
                    ),
                  ),
                ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String date = DateFormat("dd-MM-yyyy").format(DateTime.now());

          setState(() {
            DateClass dateClass =
                DateClass(currentDate: date, isWorkCompleted: 0);
            dateArray.add(dateClass);

            TrackerDescription td = TrackerDescription(
                date: dateClass.currentDate,
                isTaskComplete: dateClass.isWorkCompleted,
                title: widget.trackerDescription.title,
                description: widget.trackerDescription.description);

            DatabaseHelper.db.insertNewValue(td);
          });
        },
        child: Center(child: Text("Add Date")),
      ),
    );
  }

  showDialogBox(BuildContext context, int index) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                  width: 300,
                  height: 150,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "Have you done your today's task ?",
                            style: TextStyle(fontSize: 20.0),
                            maxLines: 2,
                          ),
                        ),
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CupertinoButton(
                                child: Icon(Icons.thumb_up),
                                onPressed: () {
                                  setState(() {
                                    dateArray[index].isWorkCompleted = 1;
                                    TrackerDescription td = TrackerDescription(
                                        date: dateArray[index].currentDate,
                                        description: widget
                                            .trackerDescription.description,
                                        title: widget.trackerDescription.title);
                                    var result =
                                        DatabaseHelper.db.updateDateTask(td);
                                    print(result);
                                    Navigator.pop(context);
                                  });
                                }),
                            CupertinoButton(
                                child: Icon(Icons.thumb_down),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        ),
                      )
                    ],
                  )));
        });
  }
}

class DateClass {
  final String currentDate;
  int isWorkCompleted;

  DateClass({this.currentDate, this.isWorkCompleted});

  void setworkProgress(int isCompleted) {
    this.isWorkCompleted = isCompleted;
  }

  factory DateClass.fromMap(Map<String, dynamic> data) {
    return DateClass(
        currentDate: data['currentDate'],
        isWorkCompleted: data['isWorkCompleted']);
  }

  Map<String, dynamic> toMap() =>
      {"currentDate": currentDate, "isWorkCompleted": isWorkCompleted};
}

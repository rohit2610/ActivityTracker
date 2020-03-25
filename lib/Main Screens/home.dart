import 'package:activity_tracker/Main%20Screens/decription_details_edit_screen.dart';
import 'package:activity_tracker/Main%20Screens/description_details_screen.dart';
import 'package:activity_tracker/Model/tracker_description.dart';
import 'package:flutter/material.dart';
import 'package:activity_tracker/utils/data_helper_class.dart';

class Home extends StatefulWidget {
  //const Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int count = 2;

  List<EntryDetails> entryDetailsList = [];
  //entryDetailsList.add(trackerDescription);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataOnStart();
  }

  getDataOnStart() async {
    var result = await DatabaseHelper.db.getAllValues();
    setState(() {
      entryDetailsList = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Screen"),
        ),
        body: ListView.builder(
            itemCount: entryDetailsList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditDescription(
                                entryDetails: entryDetailsList[index],
                                index: index,
                              )));
                },
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                        child: Column(
                      children: <Widget>[
                        if (entryDetailsList.isNotEmpty)
                          ListTile(
                            title: Text(entryDetailsList[index].title),
                            subtitle:
                                Text(entryDetailsList[index].description),
                          )
                      ],
                    ))),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // _addItem();
            TrackerDescription t = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => DescriptionScreen()));

            setState(() {
              if (t != null) {
                EntryDetails ed =
                    EntryDetails(description: t.description, title: t.title);
                entryDetailsList.add(ed);
              }
            });
          },
          child: Icon(Icons.add),
        ));
  }
}

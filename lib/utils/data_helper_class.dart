import 'package:activity_tracker/Model/tracker_description.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:activity_tracker/Main Screens/progress_report.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper db = DatabaseHelper._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "Activites.db");
    print(path);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  _createDB(Database db, int version) async {
    await db.execute("CREATE TABLE Activity (  "
        "title TEXT,"
        "description TEXT,"
        "date TEXT,"
        "isTaskComplete INTEGER"
        ") ");
  }

  // insert new values
  insert(TrackerDescription trackerDescription) async {
    final db = await database;

    var result = await db.insert("Activity", trackerDescription.toMap());
    return result;
  }

  // fetch all values
  Future<List<EntryDetails>> getAllValues() async {
    final db = await database;
    List<Map> results =
        await db.rawQuery("SELECT DISTINCT title , description FROM Activity ");

    List<EntryDetails> description = new List();

    results.forEach((result) {
      EntryDetails td = EntryDetails.fromMap(result);
      description.add(td);
    });

    return description;
  }

  Future<dynamic> update(
      TrackerDescription trackerDescription, int index) async {
    final db = await database;
    List<Map> results = await db.query("Activity");
    TrackerDescription td = TrackerDescription.fromMap(results[index]);
    print(td.description);

    String title = td.title;
    print(title);
    print(results[index]);

    var result = await db.update("Activity", trackerDescription.toMap(),
        where: "title = ?", whereArgs: [title]);

    return result;
  }

  insertNewValue(TrackerDescription trackerDescription) async {
    Database db = await database;

    var result = await db.insert("Activity", trackerDescription.toMap());

    print(result);
  }

  Future<List<DateClass>> getDates(EntryDetails entryDetails) async {
    Database db = await database;

    List<DateClass> list = new List();

    List<Map> result = await db.query("Activity",
        where: "title = ? and description = ?",
        whereArgs: [entryDetails.title, entryDetails.description]);

    result.forEach((item) {
      TrackerDescription td = TrackerDescription.fromMap(item);
      DateClass dc =
          DateClass(currentDate: td.date, isWorkCompleted: td.isTaskComplete);
      list.add(dc);
    });

    return list;
  }

  Future updateDateTask(TrackerDescription trackerDescription) async {
    Database db = await database;

    trackerDescription.isTaskComplete = 1;
    var result = db.update("Activity", trackerDescription.toMap(),
        where: "title = ? and description = ? and date = ?",
        whereArgs: [
          trackerDescription.title,
          trackerDescription.description,
          trackerDescription.date
        ]);

    return result;
  }

  removeDate(EntryDetails entryDetails, String date) async {
    Database db = await database;

    db.delete("Activity",
        where: "title = ? and description = ? and date = ?",
        whereArgs: [entryDetails.title, entryDetails.description, date]);
  }

  removeEntryDetails(EntryDetails entryDetails)async{
    Database db = await database;

    db.delete("Activity",
    where : "title = ? and description = ?",
    whereArgs : [entryDetails.title , entryDetails.description]);
  }
}

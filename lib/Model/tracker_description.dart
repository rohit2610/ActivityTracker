class TrackerDescription{
  final String title;
  final String description;
  final String date;
  int isTaskComplete ;

  
  static final columns = ["title" , "description","date","isTaskComplete"];
  
  TrackerDescription({this.title,this.description,this.date,this.isTaskComplete});
  

  factory TrackerDescription.fromMap(Map<String,dynamic> data){
    return TrackerDescription(
      title : data['title'],
      description: data['description'],
      date : data['date'],
      isTaskComplete: data['isTaskComplete']
    );
  }

  Map<String , dynamic> toMap() => {
    "title" : title,
    "description" : description,
    "date" : date,
    "isTaskComplete" : isTaskComplete
    };

  
  


}

class EntryDetails{
  final String title;
  final String description;

  EntryDetails({this.description,this.title});

  factory EntryDetails.fromMap(Map<String,dynamic> data){
    return EntryDetails(
      title : data['title'],
      description : data['description']
    );
  }

  Map<String , dynamic> toMap() => {
    'title' : this.title,
    'description' : this.description
  };
}
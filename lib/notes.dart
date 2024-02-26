

class Note{
  
     int? id;
    String title;
    String description;
    String date;
    int priority;

  Note ({this.id,required this.title, required this.date, required this.description, required this.priority});
  //Note.withId(this._id,this._priority,this._date,this._description,this._title);

  //  int? get id => _id;
  // String? get title=>_title;
  // String? get description=>_description;
  // String? get date=>_date;
  // int? get priority=>_priority;



   // set sTitle(String newTitle){
   //   this.title=newTitle;
   // }
  // set sDescription(String newDescription){
  //   this.description=newDescription;
  // }
  // set sDate(String newDate){
  //   this.date=newDate;
  // }
  // set sPriority(int newPriority){
  //   this.priority=newPriority;
  // }



// convert a map object into a todoapp object
 Note.fromMap(Map<String,dynamic> map):
    id = map['id'],
   title=map['title'],
   description=map['description'],
   date = map['date'],
   priority=map['priority'];



  //convert a todoapp object into a map object
  Map<String,Object?> toMap (){
    return{
      'id':id,
      'priority':priority,
      'title':title,
      'description':description,
      'date':date
    };
  }
}
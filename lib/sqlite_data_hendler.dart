

import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql_database_todo_app/notes.dart';

class DatabaseHendler{

  //name
  static const _databaseName='notes.db';
  //static final _databaseVersion=1;
  //table name
  String tableName='notes';
  // String colId='id';
  // String colTitle='title';
  // String colDescription='description';
  // String colPriority='priority';
  // String colDate ='date';


  // a Database
   static Database? _database;

   // database instance
    static DatabaseHendler databaseHendler = DatabaseHendler();


   Future<Database?> get database async{
     if(_database != null){
       return _database;
     }else{
     _database= await initialzeDatabase();
     return _database;
     }
   }

  initialzeDatabase()async{
     io.Directory directory=await getApplicationDocumentsDirectory();
     String path= join(directory.path,'notes.db');
     var todoDatabase=await openDatabase(path,version: 1,onCreate: _createDb);
     return todoDatabase;
  }


  _createDb (Database db, int version) async {
     await db.execute('''CREATE TABLE notes (
                          id INTEGER PRIMARY KEY AUTOINCREMENT,
                          title TEXT,
                          description TEXT,
                          date TEXT,
                          priority INTEGER
                                  )
                        ''');
   }
  
  //fetch operation : get all note object from database
Future<List<Map<String,Object?>>> getNoteMapList()async{
     Database? db=await database;
    var result = await  db!.query(tableName,orderBy: 'priority ASC');
    return result;
}

//Insert Data
Future<Note> insertNote(Note note)async{
     var db=await database;
     await db!.insert(tableName, note.toMap());
     return note;
}
//Update Data
Future<int> updateNote(Note note)async{
     Database? db=await database;
     var result=await db!.update(tableName, note.toMap(),where:'id=?',whereArgs: [note.id]);
     return result;
}

// deleteData
Future<int> deleteNote(int id)async{
     Database? db = await database;
     int result=await db!.delete(tableName,where: 'id=?',whereArgs: [id]);
     return result;
}

// Get number of Note objects database
Future<int?> getCount()async{
     Database? db=await database;
     List<Map<String,Object?>> x =await db!.rawQuery('SELECT COUNT(*) FROM $tableName');
     var result= Sqflite.firstIntValue(x);
     return result;
}
// data convert map object to list object
Future<List<Note>> getNoteList() async {
     var mapNoteList= await getNoteMapList();
     List<Note> noteList= mapNoteList.map((e) => Note.fromMap(e)).toList();
      return noteList;
}

}

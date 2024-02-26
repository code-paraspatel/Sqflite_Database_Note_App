import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sql_database_todo_app/notes.dart';
import 'package:sql_database_todo_app/sqlite_data_hendler.dart';



class EditPage extends StatefulWidget {
  const EditPage({Key? key, required this.title, required this.note}) : super(key: key);
  final Note note;
  final String title;
  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  DatabaseHendler? databaseHendler;

  TextEditingController titleController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHendler=DatabaseHendler();
  }
  final _priority = ['High','Low'];
  //var selected = 'Low';
  @override
  Widget build(BuildContext context) {
    titleController.text=widget.note.title.toString();
    descriptionController.text=widget.note.description.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,style: const TextStyle(fontSize: 18),),
        actions: [
          IconButton(onPressed:() {
            deleteData();
          },
              icon: const Icon(Icons.delete,size: 30,),color: Colors.black45),
          IconButton(
              onPressed: () {
                saveData();
              },
              icon: const Icon(Icons.check,size: 30,),color: Colors.black45,),
          const SizedBox(width: 10,),
        ],
      ),
      body: Container(color: Colors.blue.shade50,
        child: Padding(
          padding: const EdgeInsets.only(top: 20,left: 8,right: 15),
          child: ListView(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TextField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(fontSize: 13),
                      controller: titleController,
                      decoration: InputDecoration(
                        //label: const Text('title'),
                        hintStyle: const TextStyle(fontSize: 20,color: Colors.black45,),
                          hintText: 'Title',
                          border: OutlineInputBorder(
                            gapPadding: 2.0,
                              borderRadius: BorderRadius.circular(10),
                             borderSide: BorderSide.none
                          )
                      ),
                      onChanged: (value) {
                        widget.note.title=titleController.text;
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                    //  border: Border.all(style: BorderStyle.none),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: 100,
                    height: 50,
                    child: Center(
                      child: DropdownButton(
                        underline: const SizedBox(),
                          items: _priority.map((e) => DropdownMenuItem(
                            value: e,
                              child: Text(e.toString(),style: const TextStyle(color: Colors.black45,fontSize: 15),)
                          )
                          ).toList(),
                          onChanged:(value) {
                            setState(() {
                                updatePriorityAsInt(value ?? _priority[0]);
                            });
                          },
                        value:updatePriorityAsString(widget.note.priority),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text('${DateFormat.yMMMMd().format(DateTime.now())},${DateFormat.jm().format(DateTime.now())}',
                    style: const TextStyle(fontSize: 10,color: Colors.black45),),
              ),
             // SizedBox(height: MediaQuery.of(context).size.height*0.001,),
              const Divider(height: 1),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.7,
                child: TextField(
                  maxLines: null,
                  style: const TextStyle(fontSize: 15),
                  keyboardType: TextInputType.multiline,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: const TextStyle(fontSize: 15,color: Colors.black45,),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                  onChanged: (value) {
                    widget.note.description=descriptionController.text;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Move to Last Screen
  moveToLastScreen(){
    Navigator.pop(context,true);
  }
  //update priority into string to int
void updatePriorityAsInt(String priority){
    switch (priority){
      case 'High':
        widget.note.priority=1;
        break;
      case 'Low':
        widget.note.priority=2;
        break;
      default:
        widget.note.priority=1;
    }
}

String updatePriorityAsString(int value){
    String? priority;
    switch (value){
      case 1:
        priority=_priority[0];
        break;
      case 2:
        priority=_priority[1];
        break;
      default:
        priority=_priority[0];
    }
    return priority;
}


  //Delete data
  // _deleteData()async{
  //   //case 1: If user is trying to delete the New Note i.e he has come to
  //   // the details page by pressing the Fab of NoteList page.
  //   if(widget.note.id == null){
  //     _showAlterDialog('Status', 'No Note was deleted');
  //   }
  //   //case 2: User is trying to delete the old note that already has a valid id.
  //   int result=await databaseHendler!.deleteNote(widget.note.id!);
  //   if (result != 0){
  //     _showAlterDialog('Status', 'Note Deleted Successfully');
  //   }else{
  //     _showAlterDialog('Status', 'Error Occurred While Deleted Note');
  //   }
  //   moveToLastScreen();
  // }

deleteData()async{
    int? result;
    if(widget.note.id != null){
      moveToLastScreen();
      result = await databaseHendler!.deleteNote(widget.note.id!);
    }
      if(result != 0){
        _showAlterDialog('Status', 'Note Delete Successfully ');
      }else{
        _showAlterDialog('Status', 'No Note was Deleted');
    }
}

saveData()async{
    moveToLastScreen();
    widget.note.date='${DateFormat.yMMMMd().format(DateTime.now())},${DateFormat.jm().format(DateTime.now())}';
    if(widget.note.id != null){
      await databaseHendler!.updateNote(widget.note);
      _showAlterDialog('Status', 'Update Data Successfully');
    }else if(widget.note.id == null){
       await databaseHendler!.insertNote(widget.note);
       _showAlterDialog('Status', 'Save Data Successfully');
    }else{
      _showAlterDialog('Status', 'Error Occurred Saving Data');
    }

}



//save Data
// void _saveData()async{
//      moveToLastScreen();
//     widget.note.sDate=DateFormat.yMMMd().format(DateTime.now());
//     int result;
//     if(widget.note.id !=null){ // case 1:Update a Data
//       result=await databaseHendler!.updateNote(widget.note);
//     }else{
//       result=await databaseHendler!.insertNote(widget.note);
//     }
//     if (result!=0){
//       _showAlterDialog('Status','Note Saved Successfully');
//     }else{
//       _showAlterDialog('Status','Problem Saving Note');
//     }

// }
  void _showAlterDialog(String title,String message){
    AlertDialog alertDialog =AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (context) {
      return alertDialog;
    },);
  }

}

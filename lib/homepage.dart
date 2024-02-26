import 'package:flutter/material.dart';
import 'package:sql_database_todo_app/edit_page.dart';
import 'package:sql_database_todo_app/exit_app_dialogbox.dart';
import 'package:sql_database_todo_app/notes.dart';
import 'package:sql_database_todo_app/sqlite_data_hendler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHendler? databaseHendler;
  int count=0;
  @override
  void initState() {
    super.initState();
    databaseHendler=DatabaseHendler();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => ExitAppDialog().exitAppButtonPress(context),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Notes'),
        ),
        body: Container(
          color: Colors.blue.shade50,
          child: FutureBuilder(
              future: databaseHendler!.getNoteList(),
              builder: (context,AsyncSnapshot<List<Note>> snapshot) {
                if(snapshot.hasData){
                return ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    return  InkWell(
                      onTap: (){
                        navigationPage(snapshot.data![index], 'Edit Note');
                      },
                      child: Card(
                        color: Colors.cyan.shade100,
                        margin: const EdgeInsets.only(top: 15,left: 10,right: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: getPriorityColor(snapshot.data![index].priority),
                                child: getPriorityIcon(snapshot.data![index].priority),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              width: MediaQuery.of(context).size.width*0.6,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                               mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text(snapshot.data?[index].title.toString() ?? 'Titel',
                                           style: Theme.of(context).textTheme.titleMedium,
                                     maxLines: 1,
                                     overflow: TextOverflow.ellipsis,
                                   ),
                                const SizedBox(height: 5,),
                                Text(
                                  snapshot.data?[index].description.toString() ?? 'Description',
                                 maxLines: 1,
                                 overflow: TextOverflow.ellipsis,
                                 style: const TextStyle(fontSize: 12),
                                 // overflow: TextOverflow.ellipsis,
                                ),
                                  const SizedBox(height: 5,),
                                  Text(snapshot.data?[index].date.toString()??'Date',
                                      maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(onPressed: () {
                                delete(snapshot.data![index].id!);
                                setState(() {
                                  snapshot.data!.remove(snapshot.data![index]);
                                });
                              },
                                  icon: const Icon(Icons.delete)),
                            )
                          ],
                        ),
                      ),
                    );
                  },);
                }else{
                  return Container();
                }
              },),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
               navigationPage(Note(title: '', date:'', description:'', priority:1),'Add Note');
        },),
      ),
    );
  }
  // priority of color
  Color getPriorityColor(int priority){
    switch(priority){
      case 1:
        return Colors.red; 
      case 2:
        return Colors.yellow;
      default:
        return Colors.yellow;
    }
  }
// priority of Icon
  Icon getPriorityIcon(int priority){
  switch(priority){
    case 1:
      return const Icon(Icons.play_arrow);
    case 2:
      return const Icon(Icons.arrow_forward_ios_rounded);
    default:
      return const Icon(Icons.arrow_forward_ios_rounded);
  }
  }

 // Delete Item from database
 delete (int id) async {
     await databaseHendler!.deleteNote(id);
     if(id!=0) {
       setState(() {
         databaseHendler!.getNoteList();
         showShankBar('Deleted Successfully');
       });
     }
  }

  //Show Shank bar
  showShankBar(String message){
    final snackBar=SnackBar(
      duration: const Duration(seconds: 1),
        content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Update ListView
  // Future<List<Note>> updateListView() async {
  //    try{
  //      final  db= await databaseHendler!.initialzeDatabase();
  //      db.then((value) async {
  //        List<Note> futureNoteList = await databaseHendler!.getNoteList();
  //        setState(() {
  //          noteList = futureNoteList;
  //        });
  //      });
  //      return noteList;
  //    }catch(e){
  //      throw (e.toString());
  //    }
  // }


  navigationPage(Note note,String title)async{
    bool result=await Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(note: note,title: title),));
    if(result == true){
     setState(() {
       databaseHendler!.getNoteList();
     });
    }
  }


}

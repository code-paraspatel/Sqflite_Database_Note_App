

import 'package:flutter/material.dart';

class ExitAppDialog {

  Future<bool> exitAppButtonPress(BuildContext context)async{
    bool? exitApp= await showDialog(
        context: context,
        builder:(context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.only(left:30,top: 18,bottom: 10),
            titleTextStyle: const TextStyle(fontSize: 18,color: Colors.blue),
            title: const Text('Alert'),
            contentPadding:const EdgeInsets.only(top: 15,left: 30,bottom: 40),
            contentTextStyle: const TextStyle(fontSize: 12,color: Colors.blue),
            content: const Text('Are You Sure Exit to App?'),
            actionsAlignment: MainAxisAlignment.end,
            actionsPadding: const EdgeInsets.only(bottom: 5,right: 10),
            actions: [
              TextButton(
              onPressed:() {
                //canPop=false;
                Navigator.of(context).pop(false);
              },
              child:const Text('No')),
              TextButton(
                  onPressed: () {
                  //  canPop=true;
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Yes'))
            ],
          );
        }, );
    return exitApp ?? false;
  }


}
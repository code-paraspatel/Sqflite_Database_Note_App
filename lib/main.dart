import 'package:flutter/material.dart';
import 'package:sql_database_todo_app/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.cyan)
      ),
      title: 'Flutter Demo',
     themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),
     // theme: ThemeData.light(),
      home: const MyHomePage(),
    );
  }
}
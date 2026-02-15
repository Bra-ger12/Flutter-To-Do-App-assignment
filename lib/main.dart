
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/pages/todo.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "To-Do App",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: TodoScreen(),
    );
  }
}
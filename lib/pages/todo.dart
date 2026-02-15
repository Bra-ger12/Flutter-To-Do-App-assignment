import 'package:flutter/material.dart';
import '../models/task.dart'; //
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// The main screen
class TodoScreen extends StatefulWidget {
  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Task> tasks = []; 
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks(); 
  }

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskList = prefs.getStringList('tasks');

    if (taskList != null) {
      setState(() {
        tasks = taskList
            .map((task) => Task.fromMap(jsonDecode(task)))
            .toList();
      });
    } else {
      
      tasks = [
        Task(title: "Study Flutter"),
        Task(title: "Do Assignment"),
        Task(title: "Read DevOps Notes"),
        Task(title: "Practice Coding"),
        Task(title: "Prepare for Exam"),
      ];
      saveTasks(); 
    }
  }

  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList =
        tasks.map((task) => jsonEncode(task.toMap())).toList();
    await prefs.setStringList('tasks', taskList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My To-Do App"),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          "Step 4 Complete: Tasks are loaded",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
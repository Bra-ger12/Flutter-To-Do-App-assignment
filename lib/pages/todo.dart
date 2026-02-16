import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TodoScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const TodoScreen({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Task> tasks = []; // List to store tasks
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks(); // Load tasks when app starts
  }

  // Load tasks from SharedPreferences
  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskList = prefs.getStringList('tasks');

    if (taskList != null) {
      setState(() {
        tasks =
            taskList.map((task) => Task.fromMap(jsonDecode(task))).toList();
      });
    } else {
      // For demo: add 5 default tasks
      tasks = [
        Task(title: "Study Flutter"),
        Task(title: "Do Assignment"),
        Task(title: "Read DevOps Notes"),
        Task(title: "Practice Coding"),
        Task(title: "Prepare for Exam"),
      ];
      saveTasks(); // Save default tasks
    }
  }

  // Save tasks to SharedPreferences
  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList =
        tasks.map((task) => jsonEncode(task.toMap())).toList();
    await prefs.setStringList('tasks', taskList);
  }

  // 🔹 ADD TASK (Newest First)
  void addTask() {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      tasks.insert(0, Task(title: controller.text.trim()));
    });

    controller.clear();
    saveTasks();
  }

  // 🔹 TOGGLE COMPLETE
  void toggleTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });

    saveTasks();
  }

  // 🔹 DELETE TASK
  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });

    saveTasks();
  }

  // 🔹 EDIT TASK
  void editTask(int index) {
    TextEditingController editController =
        TextEditingController(text: tasks[index].title);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Task"),
          content: TextField(
            controller: editController,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (editController.text.trim().isEmpty) return;

                setState(() {
                  tasks[index].title = editController.text.trim();
                });

                saveTasks();
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My To-Do App"),
        centerTitle: true,
        actions: [
          Switch(
            value: widget.isDarkMode,
            onChanged: (_) => widget.toggleTheme(),
            activeColor: Colors.white,
          ),
        ],
      ),

      body: Column(
        children: [

          // 🔹 Input Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter new task...",
                      hintStyle:
                          const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white24,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: addTask,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 Task List
          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    child: Text(
                      "No Tasks Yet 😊",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];

                      return Container(
                        margin:
                            const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: task.isDone
                              ? (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.green.shade800
                                  : Colors.green.shade100)
                              : Theme.of(context).cardColor,
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: task.isDone,
                            onChanged: (_) =>
                                toggleTask(index),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () =>
                                    editTask(index),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    deleteTask(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
class Task {
  String title;
  String? description; 
  DateTime? dueDate;   
  bool isDone;

  Task({
    required this.title,
    this.description,
    this.dueDate,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'isDone': isDone,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'] != null
          ? DateTime.parse(map['dueDate'])
          : null,
      isDone: map['isDone'],
    );
  }
}
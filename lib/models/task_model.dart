class Task {
  int? id;
  String title;
  String description;
  String? date;
  bool isDone;
  bool isImportant;

  Task({this.id, required this.title, required this.description, this.date, required this.isDone, required this.isImportant});

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'title': title,
      'description' : description,
      'date' : date,
      'isDone': isDone ? 1 : 0,
      'isImportant': isImportant ? 1 : 0
    };
  }
}
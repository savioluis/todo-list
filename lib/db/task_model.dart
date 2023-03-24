class TaskModel {
  late int id;
  String title;
  String? description;
  bool isDone;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.isDone = false,
  });

  factory TaskModel.fromMap(Map<String, dynamic> json) => TaskModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        isDone: json["isDone"] == 1,
      );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "title": title,
      "description": description,
      "isDone": isDone ? 1 : 0,
    };

    if (id != null) map["id"] = id;

    return map;
  }
}

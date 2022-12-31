class TaskModel {
  String? id;
  String? title;
  String? description;
  String? taskDate;
  String? taskTime;
  String? document;
  String? documentType;

  TaskModel({this.id, this.title, this.description, this.taskDate,this.taskTime,this.document,this.documentType});

  static TaskModel fromJson(String id,Map<String, dynamic> json) => TaskModel(
      id: id,
      title: json["title"],
      description: json["description"],
      taskDate: json["taskDate"],
      taskTime: json["taskTime"],
      document: json["document"],
    documentType: json["documentType"]
  );
}


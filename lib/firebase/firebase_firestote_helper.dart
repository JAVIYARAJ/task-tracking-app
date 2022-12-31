import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_tracker/firebase/task.dart';

class FirebaseHelper {
  //fire store instance
  static final database = FirebaseFirestore.instance;

  //fetch category data from firebase
  static Stream<List<TaskModel>> fetchCategory(String category) => database
      .collection(category)
      .snapshots() //contain whole snapshot of data
      .map((value) => value.docs //contain all document inside this snapshot
              .map((doc) =>
                  TaskModel.fromJson(doc.id, doc.data())) //contain map value in doc
              .toList() //converted this map value in list
          );

  static Future<List<TaskModel>> fetchCategoryWithFilter(String category, String filter) async {
    var ref = await database
        .collection(category)
        .where("title", isGreaterThanOrEqualTo: filter.toUpperCase())
        .limit(1)
        .get();
    var data =
        ref.docs.map((docs) => TaskModel.fromJson(docs.id, docs.data())).toList();
    return data;
  }

  static Future<double> getCategoryTasksNumber(String category) async {
    var length = await database.collection(category).count().get();
    return length.count.toDouble();
  }

  //add new task in fire store database
  static void addTask(TaskModel task, String category) async {
    var temp = await database.collection(category).add({
      "title": task.title,
      "description": task.description,
      "taskDate": task.taskDate,
      "taskTime": task.taskTime,
      "document": task.document,
      "documentType": task.documentType,
    }).then((value) => debugPrint("Data added into firebase"));
  }


  static void deleteTask(String key, String category) async {
    await database.collection(category).doc(key).delete();
  }

  static Future<void> updateTask(String key, String category, String title, String description) async {
    try {
      await database
          .collection(category)
          .doc(key)
          .update({"title": title, "description": description}).then((value) {
        debugPrint("firebase update complete");
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

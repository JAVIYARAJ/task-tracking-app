import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseStorageHelper {
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  static Future<void> uploadDocument(String fileName, String filePath) async {
    final path = "files/$fileName";
    final file = File(filePath);
    final ref = firebaseStorage.ref().child(path);
    final doc=await ref.putFile(file).whenComplete(() async {

      final docUrl= await ref.getDownloadURL();
      debugPrint("Document uploaded successfully And Url is $docUrl}");
    });
  }
}

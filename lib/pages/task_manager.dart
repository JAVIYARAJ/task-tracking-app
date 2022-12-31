import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:task_tracker/components/reusable_button.dart';
import 'package:task_tracker/firebase/firebase_firestote_helper.dart';
import 'package:task_tracker/firebase/task.dart';
import 'package:motion_toast/motion_toast.dart';
import '../Constant/constant.dart';

class TaskManager extends StatefulWidget {
  const TaskManager({Key? key}) : super(key: key);

  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  //properties
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  String? selectedTag = "id";
  String? selectedTaskCategory = "Home";
  String? documentType = "pdf";

  String taskDateAndTime = "Select Date And Time";
  String? taskDate;
  String? taskTime;
  PlatformFile? pickedFile;
  String? documentUrl;

  //methods
  Future<TimeOfDay?> _showTimePicker() async {
    DateTime initialDate = DateTime.now();
    return await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: initialDate.hour, minute: initialDate.minute));
  }

  //date and time picker
  Future<void> _showDateAndTimePicker() async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2001);
    DateTime lastDate = DateTime(2025);

    await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: firstDate,
            lastDate: lastDate)
        .then((date) async {
      TimeOfDay? time = await _showTimePicker();
      if (date != null && time != null) {
        setState(() {
          taskDate = DateFormat('dd/MM/yyy').format(date);
          taskTime = "${time.hour - 12}:${time.minute}";
          taskDateAndTime =
              "${DateFormat('dd/MM/yyy').format(date)} ${time.hour - 12}:${time.minute}";
        });
      } else {
        return;
      }
    });
  }

  //date and time widget
  Widget _buildDateAndTimeWidget(String value) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: sBorderRadius,
          color: const Color(0XFFd6dce9),),
      child: Center(
        child: Text(
          value,
          style: GoogleFonts.poppins(fontSize: 15),
        ),
      ),
    );
  }

  Future<void> selectDocument() async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["pdf", "jpg", "docx", "png"]);
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
      if (documentType != pickedFile?.extension) {
        MotionToast.error(
          toastDuration: const Duration(seconds: 3),
          position: MotionToastPosition.top,
          iconType: IconType.materialDesign,
          description: const Text("Please select valid document."),title: const Text("File Picker"),).show(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0XFF77a7f0),
            title: Text(
              "Task Manager",
              style: mPoppinsTextWhite,
            ),
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      AppLocalizations.of(context)?.add_your_new_task ??
                          "Add New Task",
                      style: lPoppinsTextBlack),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                            textFieldBorderRadius),
                        hintText: "Enter your task title"),
                    controller: titleController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration:  InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                textFieldBorderRadius),
                        hintText: "Enter your task description"),
                    controller: descriptionController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Select Task category",
                    style: GoogleFonts.aBeeZee(fontSize: 17),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    height: 57,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.black.withOpacity(0.6)),
                        borderRadius: textFieldBorderRadius),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          iconSize: 30,
                          isDense: true,
                          isExpanded: true,
                          value: selectedTaskCategory,
                          items: dropDownTaskCategory,
                          onChanged: (value) {
                            setState(() {
                              selectedTaskCategory = value as String?;
                            });
                          }),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Upload Document if required!",
                    style: GoogleFonts.aBeeZee(fontSize: 17),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    height: 57,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.black.withOpacity(0.6)),
                        borderRadius: textFieldBorderRadius),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          iconSize: 30,
                          isDense: true,
                          isExpanded: true,
                          value: documentType,
                          items: dropDownDocumentItems,
                          onChanged: (value) {
                            setState(() {
                              documentType = value as String?;
                            });
                            debugPrint("Selected Doc Type $documentType");
                          }),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      selectDocument();
                    },
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: const Color(0XFFd6dce9),
                          borderRadius: sBorderRadius),
                      child: Center(
                          child: Text(
                        pickedFile?.name ?? "Select Document",
                        style: GoogleFonts.poppins(fontSize: 15),
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      onTap: () {
                        _showDateAndTimePicker();
                      },
                      child: _buildDateAndTimeWidget(taskDateAndTime)),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                        onTap: () async {
                          if (pickedFile != null) {
                            FirebaseStorage firebaseStorage =
                                FirebaseStorage.instance;
                            final path = "files/${pickedFile?.name}";
                            final file = File((pickedFile?.path ?? ""));
                            final ref = firebaseStorage.ref().child(path);

                            await ref.putFile(file).whenComplete(() async {
                              documentUrl = await ref.getDownloadURL();
                            });
                          } else {}
                          FirebaseHelper.addTask(
                              TaskModel(
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  taskDate: taskDate,
                                  taskTime: taskTime,
                                  document: documentUrl,
                                  documentType: pickedFile?.extension),
                              selectedTaskCategory!);
                          // titleController.text = "";
                          // descriptionController.text = "";
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        },
                        child: ReusableWidgets.buildButton(
                            AppLocalizations.of(context)?.add_new_task ??
                                "Add New Task")),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

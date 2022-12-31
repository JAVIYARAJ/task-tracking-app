import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:task_tracker/PDFManager/pdf_manager.dart';
import 'package:task_tracker/StateManagement/state_management.dart';
import 'package:task_tracker/components/reusable_button.dart';
import 'package:task_tracker/firebase/firebase_firestote_helper.dart';
import 'package:task_tracker/firebase/task.dart';
import 'package:task_tracker/pages/document_view_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Constant/constant.dart';

class TaskCategoryPage extends StatefulWidget {
  var category;

  TaskCategoryPage({Key? key, this.category}) : super(key: key);

  @override
  State<TaskCategoryPage> createState() => _TaskCategoryPageState();
}

class _TaskCategoryPageState extends State<TaskCategoryPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController searchTaskController = TextEditingController();

  //bottom modal sheet for add new task or update new task
  Future<void> _showUpdateModalSheet(String key, String title, String description) async {
    if (title.isNotEmpty && description.isNotEmpty) {
      titleController.text = title;
      descriptionController.text = description;

      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (_) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      AppLocalizations.of(context)?.update_task ??
                          "Update Task",
                      style: lPoppinsTextBlack),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        hintText: "Enter your task title"),
                    controller: titleController,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        hintText: "Enter your task description"),
                    controller: descriptionController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                        onTap: () async {
                          FirebaseHelper.updateTask(key, widget.category,
                              titleController.text, descriptionController.text);
                          //titleController.text = "";
                          //descriptionController.text = "";
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        },
                        child: ReusableWidgets.buildButton(
                            AppLocalizations.of(context)?.update_task ??
                                "Update Task")),
                  ),
                ],
              ),
            );
          });
    } else {
      return;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String filterText = "";

    Widget _buildSearchWidget() {
      return Container(
        margin: const EdgeInsets.all(5),
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: sBorderRadius,
        ),
        child: TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: sBorderRadius),
            hintText: "Enter keyword",
          ),
          onChanged: (String value) {
            setState(() {
              filterText = value;
            });
          },
          controller: searchTaskController,
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            _buildSearchWidget(), //filter text field
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder<List<TaskModel>>(
                stream:
                    FirebaseHelper.fetchCategory(widget.category.toString()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<TaskModel>? data = snapshot.data;

                    return StaggeredGridView.countBuilder(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        itemCount: data?.length,
                        crossAxisCount: 2,
                        itemBuilder: (context, index) {
                          String? title = data![index].title!;
                          String desc = data[index].description!;
                          String dateAndTime =
                              "${data[index].taskDate} ${data[index].taskTime}";
                          String? document = data[index].document;
                          String? documentType = data[index].documentType;

                          String? documentImage = "assets/document_icon.png";

                          //use for document image
                          if (documentType == "pdf") {
                            documentImage = "assets/pdf_icon.png";
                          } else if (documentType == "docx") {
                            documentImage = "assets/document_icon.png";
                          } else if (documentType == "jpg" ||
                              documentType == "png") {
                            documentImage = "assets/image_icon.png";
                          }

                          return Consumer<TaskAppDataNotifier>(
                            builder: (context, notifier, child) {
                              return Card(
                                elevation: 5,
                                color: Color(notifier.taskColor),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: taskGoogleFont,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(desc, style: taskGoogleFont),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                _showUpdateModalSheet(
                                                    data[index].id!,
                                                    data[index].title!,
                                                    data[index].description!);
                                              },
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                    borderRadius: sBorderRadius,
                                                    color: Colors.transparent),
                                                child: const Image(
                                                  image: AssetImage(
                                                      "assets/edit_icon.png"),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                FirebaseHelper.deleteTask(
                                                  data[index].id!,
                                                  widget.category,
                                                );
                                              },
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                    borderRadius: sBorderRadius,
                                                    color: Colors.white),
                                                child: const Image(
                                                  image: AssetImage(
                                                      "assets/delete_icon.png"),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            document?.length != null
                                                ? InkWell(
                                                    onTap: () async {

                                                      String? pdfPath; //use for pdf view
                                                      WebViewController? wevViewController; //use for web view (image)

                                                      if (documentType ==
                                                          "pdf") {
                                                        pdfPath = await PdfManager
                                                            .loadPdf(document!,
                                                                documentType!);
                                                      }else if(documentType=="jpg" || documentType=="png"){
                                                         wevViewController= WebViewController()
                                                          ..setJavaScriptMode(JavaScriptMode.unrestricted)
                                                          ..setBackgroundColor(Colors.white)
                                                          ..loadRequest(Uri.parse(document!));
                                                      }
                                                      else{
                                                        pdfPath=null;
                                                        wevViewController=null;
                                                      }

                                                      // ignore: use_build_context_synchronously
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DocumentWebView(
                                                                    path: pdfPath,
                                                                    documentType:
                                                                        documentType,
                                                                    controller: wevViewController,
                                                                  )));
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              sBorderRadius,
                                                          color: Colors.transparent),
                                                      child: Image(
                                                        image: AssetImage(
                                                            documentImage!),
                                                      ),
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(dateAndTime,
                                              style:
                                                  taskDateAndTimeGoogleFont)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        staggeredTileBuilder: (index) =>
                            const StaggeredTile.fit(1));
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.grey,
                        color: Colors.teal,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}

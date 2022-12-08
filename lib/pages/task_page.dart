import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:task_tracker/DbHelper/database_helper.dart';
import 'package:task_tracker/pages/setting_page.dart';
import 'package:task_tracker/StateManagement/state_management.dart';
import 'package:translator/translator.dart' as text;

import '../AppTheme/app_theme.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  List<Map<String, dynamic>> items = [];

  List<Map<String, dynamic>> translatedTextItems = [];

  String? selectedTag = "id";

  var dropDownList = [
    DropdownMenuItem(
        value: "id",
        child: Text(
          "Sort by id",
          style: GoogleFonts.montserrat(fontSize: 25, color: Colors.black),
        )),
    DropdownMenuItem(
        value: "title",
        child: Text(
          "Sort by title",
          style: GoogleFonts.montserrat(fontSize: 25, color: Colors.black),
        )),
    DropdownMenuItem(
        value: "description",
        child: Text(
          "Sort by description",
          style: GoogleFonts.montserrat(fontSize: 25, color: Colors.black),
        )),
    DropdownMenuItem(
        value: "createdAt",
        child: Text(
          "Sort by date",
          style: GoogleFonts.montserrat(fontSize: 25, color: Colors.black),
        )),
  ];

  final translator = text.GoogleTranslator();

  Widget _buildButton(String buttonName) {
    return Container(
      height: 50,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(colors: [
          Colors.cyanAccent.withOpacity(0.4),
          Colors.teal.withOpacity(0.4),
          Colors.indigoAccent.withOpacity(0.4),
        ]),
      ),
      child: Center(
        child: Text(
          buttonName,
          style: GoogleFonts.aladin(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
    );
  }

  Future<void> _showAddItemSheet(int? id) async {
    if (id != null) {
      //here first where method return first data that satisfy defined condition.
      final existingData = items.firstWhere((element) => element["id"] == id);
      titleController.text = existingData["title"];
      descriptionController.text = existingData["description"];
    }

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
                Text(AppLocalizations
                    .of(context)
                    ?.add_your_new_task ?? "add_new_task",
                    style: GoogleFonts.nerkoOne(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      hintText: "Enter your task title"),
                  controller: titleController,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      hintText: "Enter your task description"),
                  controller: descriptionController,
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () async {
                        if (id == null) {
                          setState(() {});
                          await _addItem();
                        } else {
                          await _updateItem(id);
                        }
                        titleController.text = "";
                        descriptionController.text = "";
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      child: _buildButton(
                          id == null
                              ? AppLocalizations
                              .of(context)
                              ?.add_new_task ?? "Add New Task"
                              : AppLocalizations
                              .of(context)
                              ?.update_task ?? "Update Task")),
                ),
              ],
            ),
          );
        });
  }

  void _reLoadData(String tag) async {
    final data = await DatabaseHelper.getItems(tag);
    setState(() {
      items = data;
    });
    debugPrint("total items from init block ${items.length}");
  }

  Future<void> _addItem() async {
    await DatabaseHelper.createItem(
        titleController.text, descriptionController.text);
    _reLoadData(selectedTag!);
  }

  Future<void> _updateItem(int id) async {
    await DatabaseHelper.updateItem(
        id, titleController.text, descriptionController.text);
    _reLoadData(selectedTag!);
  }

  Future<void> _deleteItem(int id) async {
    await DatabaseHelper.deleteItem(id);
    _reLoadData(selectedTag!);
  }

  String getDateAndTime(int index) {
    final date = DateTime.parse(items[index]["createdAt"]).toLocal();
    return "${date.day}-${date.month}-${date.year}";
  }

  Future<void> _showFilterModalSheet() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 200,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Sort by",
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    )),
                const SizedBox(
                  height: 30,
                ),
                Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) {
                    return DropdownButton<String>(
                        isExpanded: true,
                        value: notifier.filterTagName ?? "id",
                        items: dropDownList,
                        onChanged: (value) {
                          setState(() {
                            selectedTag = value;
                            notifier.setFilterTagName(value!);
                          });
                          _reLoadData(selectedTag!);
                        });
                  },
                )
              ],
            ),
          );
        });
  }

  void _loadItems() async {
    final items = await DatabaseHelper.getItemsWithSpecificLanguage(
        selectedTag ?? "title", "ml");
    debugPrint(items.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_loadItems();
    _reLoadData(selectedTag!);
  }

  Future<String> _translateText(String message, String languageCode) async {
    final text = await translator.translate(
        message, from: "auto", to: languageCode);
    return text.text;
  }

  _translateItems(List<Map<String, dynamic>> items, String languageCode) async {
    for (int i = 0; i < items.length; i++) {
      final title = await _translateText(items[i]["title"], languageCode);
      final description = await _translateText(
          items[i]["description"], languageCode);

      final item = {"title": title, "description": description};
      translatedTextItems.add(item);
    }
  }


  @override
  Widget build(BuildContext context) {
    String createdAT = AppLocalizations
        .of(context)
        ?.createdAt ??
        "createdAt";

    return Consumer<ThemeNotifier>(
      builder: (context, notifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: notifier.darkTheme! ? dark : light,
          home: Scaffold(
              appBar: AppBar(
                actions: [
                  Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                              onTap: () async {
                                _showFilterModalSheet();
                              },
                              child: const Icon(
                                Icons.filter_list,
                                size: 25,
                              ))),
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: GestureDetector(
                            onTap: () {
                              //_showSettingMenu();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const SettingPage()));
                            },
                            child: const Icon(
                              Icons.settings,
                              size: 25,
                            )),
                      ),
                    ],
                  ),
                ],
                title: Text(
                  AppLocalizations
                      .of(context)
                      ?.app_name ?? "App",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 25),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  _showAddItemSheet(null);
                },
                child: const Icon(Icons.add),
              ),
              body: RefreshIndicator(
                strokeWidth: 3,
                color: Color(notifier.taskColor),
                onRefresh: () async {
                  _reLoadData(selectedTag!);
                },
                child: Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) {
                    return StaggeredGridView.countBuilder(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        itemCount: items.length,
                        crossAxisCount: 2,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 5,
                            color: Color(notifier.taskColor),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    items[index]["title"],
                                    style: GoogleFonts.aBeeZee(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(items[index]["description"],
                                      style: GoogleFonts.kanit(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            await _showAddItemSheet(
                                                items[index]["id"]);
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(9),
                                                color: Colors.white),
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
                                            await _deleteItem(
                                                items[index]["id"]);
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(9),
                                                color: Colors.white),
                                            child: const Image(
                                              image: AssetImage(
                                                  "assets/delete_icon.png"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                          "$createdAT ${getDateAndTime(
                                              index)}",
                                          style: GoogleFonts.nerkoOne(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal))),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        staggeredTileBuilder: (index) =>
                        const StaggeredTile.fit(1));
                  },
                ),
              )),
        );
      },
    );
  }
}

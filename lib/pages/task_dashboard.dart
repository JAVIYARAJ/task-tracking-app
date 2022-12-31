import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:task_tracker/Constant/constant.dart';
import 'package:task_tracker/StateManagement/state_management.dart';
import 'package:task_tracker/pages/setting_page.dart';
import 'package:task_tracker/pages/task_category.dart';
import 'package:task_tracker/pages/task_manager.dart';

import '../AppTheme/app_theme.dart';
import '../firebase/firebase_firestote_helper.dart';

class TaskAppDashboard extends StatefulWidget {
  const TaskAppDashboard({Key? key}) : super(key: key);


  @override
  State<TaskAppDashboard> createState() => _TaskAppDashboardState();
}

class _TaskAppDashboardState extends State<TaskAppDashboard> {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String? selectedTag = "id";
  String? selectedTaskCategory = "Home";

  bool? isLoading = true;


  //use for pie chart to show all data
  double homeCategoryTask = 0;
  double educationCategoryTask = 0;
  double examCategoryTask = 0;
  double festivalCategoryTask = 0;
  double othersCategoryTask = 0;

  //shimmer category widgets
  Widget _buildCategoryShimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.6),
      highlightColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: const EdgeInsets.all(5),
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: sBorderRadius),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: mBorderRadius,
                  color: Colors.grey.withOpacity(0.4),
                ),
                height: 40,
                width: 60,
              )),
          const SizedBox(
            height: 2,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: sBorderRadius),
            height: 10,
            width: 60,
          )
        ],
      ),
    );
  }

  //shimmer pie chart widget
  Widget _buildPieChartWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.only(left: 5),
        margin: const EdgeInsets.all(5),
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            borderRadius: sBorderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 5,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: sBorderRadius),
            ),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Container(
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //use for shimmer effect (only 4 second animation show after that main content show)
  _loadingTimer() {
    Timer(const Duration(seconds: 4), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  //use for pie chart to get all category task length
  void getAllCategoryTaskLength() async {
    homeCategoryTask = await FirebaseHelper.getCategoryTasksNumber("Home");
    educationCategoryTask =
        await FirebaseHelper.getCategoryTasksNumber("Education");
    examCategoryTask = await FirebaseHelper.getCategoryTasksNumber("Exam");
    festivalCategoryTask =
        await FirebaseHelper.getCategoryTasksNumber("Festival");
    othersCategoryTask = await FirebaseHelper.getCategoryTasksNumber("Others");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    //use for shimmer effect
    _loadingTimer();

    //use for pie chart
    getAllCategoryTaskLength();

    Connectivity networkConnectivity=Connectivity();
    networkConnectivity.onConnectivityChanged.listen((result) async{
      if(result==ConnectivityResult.none){
        debugPrint("Network is off");
      }else{
        debugPrint("Network is on");
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    Map<String, double> pieChartData = {
      "Home": homeCategoryTask,
      "Education": educationCategoryTask,
      "Exam": examCategoryTask,
      "Festival": festivalCategoryTask,
      "Others": othersCategoryTask,
    };

    return Consumer<TaskAppDataNotifier>(
      builder: (context, notifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: notifier.darkTheme! ? dark : light,
          home: Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0XFF77a7f0),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SettingPage()));
                        },
                        child: const Icon(
                          Icons.settings,
                          size: largeIcon,
                        )),
                  ),
                ],
                title: Text(
                  AppLocalizations.of(context)?.app_name ?? "App",
                  style:lPoppinsTextWhite,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const TaskManager()));
                },
                child: const Icon(
                  Icons.add,
                  size: largeIcon,
                  color: iconWhite,
                ),
              ),
              body: Consumer<TaskAppDataNotifier>(
                builder: (context, notifier, child) {
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(5),
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0XFFf8cede),
                          borderRadius: sBorderRadius,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "All Task Category",
                                  style:mPoppinsTextWhite,
                                ),
                                Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        sBorderRadius),
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {});
                                        },
                                        child: const Icon(
                                          Icons.add,
                                          color: iconWhite,
                                          size: extraLargeIcon,
                                        ))),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 90,
                              width: double.infinity,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedTaskCategory = "Home";
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TaskCategoryPage(
                                                      category: "Home",
                                                    )));
                                      });
                                    },
                                    child: isLoading == true
                                        ? _buildCategoryShimmerWidget()
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 5),
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    sBorderRadius),
                                                child: const Image(
                                                  image: AssetImage(
                                                      "assets/category_home_icon.png"),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                "Home",
                                                style:
                                                sPoppinsTextWhite,
                                              ),
                                              // Container(
                                              //   height: 8,
                                              //   width: 8,
                                              //   decoration: BoxDecoration(
                                              //       color: Colors.white,
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               50)),
                                              // )
                                            ],
                                          ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedTaskCategory = "Education";
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TaskCategoryPage(
                                                    category: "Education",
                                                  )));
                                    },
                                    child: isLoading == true
                                        ? _buildCategoryShimmerWidget()
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 5),
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    sBorderRadius),
                                                child: const Image(
                                                  image: AssetImage(
                                                      "assets/category_study_icon.png"),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                "Education",
                                                style:
                                                sPoppinsTextWhite,
                                              )
                                            ],
                                          ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TaskCategoryPage(
                                                    category: "Exam",
                                                  )));
                                    },
                                    child: isLoading == true
                                        ? _buildCategoryShimmerWidget()
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 5),
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    sBorderRadius),
                                                child: const Image(
                                                  image: AssetImage(
                                                      "assets/category_exam_icon.png"),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                "Exam",
                                                style:
                                                sPoppinsTextWhite,
                                              )
                                            ],
                                          ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TaskCategoryPage(
                                                    category: "Festival",
                                                  )));
                                    },
                                    child: isLoading == true
                                        ? _buildCategoryShimmerWidget()
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 5),
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    sBorderRadius),
                                                child: const Image(
                                                  image: AssetImage(
                                                      "assets/category_festival_icon.png"),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                "Festival",
                                                style:
                                                sPoppinsTextWhite,
                                              )
                                            ],
                                          ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TaskCategoryPage(
                                                    category: "Others",
                                                  )));
                                    },
                                    child: isLoading == true
                                        ? _buildCategoryShimmerWidget()
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 5),
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    sBorderRadius),
                                                child: const Image(
                                                  image: AssetImage(
                                                      "assets/category_more_icon.png"),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                "Other",
                                                style:
                                                sPoppinsTextWhite,
                                              )
                                            ],
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      isLoading == true
                          ? _buildPieChartWidget()
                          : Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(5),
                              height: 250,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: const Color(0XFFf8cede),
                                  borderRadius: sBorderRadius),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Task Statistics",
                                      style: mPoppinsTextWhite),
                                  SizedBox(
                                    height: 200,
                                    width: double.infinity,
                                    child: PieChart(
                                      dataMap: pieChartData,
                                      animationDuration:
                                          const Duration(milliseconds: 800),
                                      chartLegendSpacing: 40,
                                      chartRadius: 200.0,
                                      colorList: const [
                                        Colors.yellow,
                                        Colors.indigoAccent,
                                        Colors.cyan,
                                        Colors.green,
                                        Colors.greenAccent
                                      ],
                                      initialAngleInDegree: 5,
                                      chartType: ChartType.disc,
                                      centerText: "TASK",
                                      legendOptions: const LegendOptions(
                                        showLegendsInRow: false,
                                        legendPosition: LegendPosition.right,
                                        showLegends: true,
                                        legendShape: BoxShape.rectangle,
                                        legendTextStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                        ),
                                      ),
                                      chartValuesOptions:
                                          const ChartValuesOptions(
                                        showChartValueBackground: true,
                                        showChartValues: true,
                                        showChartValuesInPercentage: false,
                                        showChartValuesOutside: false,
                                        decimalPlaces: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                },
              )),
        );
      },
    );
  }
}

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import 'package:task_tracker/components/reusable_button.dart';
import 'package:task_tracker/pages/task_dashboard.dart';

import '../StateManagement/state_management.dart';
import '../l10n/l10n.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  bool? isOnline;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //check that internet is one or not.
    Connectivity networkConnectivity=Connectivity();
    networkConnectivity.onConnectivityChanged.listen((result) async{
      if(result==ConnectivityResult.none){
        setState((){
          isOnline=false;
        });
      }else{
        setState((){
          isOnline=true;
        });
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>TaskAppDataNotifier(),
      child: Consumer<TaskAppDataNotifier>(
        builder: (context,notifier,child){
          return MaterialApp(
            locale: Locale(notifier.appLanguageName ?? "en"),
            localizationsDelegates:
            AppLocalizations.localizationsDelegates,
            supportedLocales: L10n.languageList,
            debugShowCheckedModeBanner: false,
            home:isOnline==false ? ReusableWidgets.buildErrorScreen() :const TaskAppDashboard(),
          );
        },
      ),
    );
  }
}

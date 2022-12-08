import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/task_page.dart';
import 'package:task_tracker/theme/app_theme.dart';
import 'l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context,notifier,child){
          return MaterialApp(
            locale: Locale(notifier.appLanguageName ?? "en"),
            localizationsDelegates:
              AppLocalizations.localizationsDelegates
            ,
            supportedLocales: L10n.languageList,
            debugShowCheckedModeBanner: false,
            home: const TaskPage(),
          );
        },
      ),
    );
  }
}


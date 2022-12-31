import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/StateManagement/state_management.dart';

import '../AppTheme/app_theme.dart';
import '../Constant/constant.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Color noteColor = Colors.deepOrange;

  String selectedLanguageName = "en";

  Future _showColorDialog() {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            actions: [
              Consumer<TaskAppDataNotifier>(
                builder: (context, notifier, child) {
                  return ElevatedButton(
                    child:
                        Text(AppLocalizations.of(context)?.got_it ?? 'Got it'),
                    onPressed: () {
                      notifier.setColor(noteColor.value);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
            title: Text(
              AppLocalizations.of(context)?.pick_a_color ?? "Pick a color!",
              style: lPoppinsTextBlack,
            ),
            content: SingleChildScrollView(
                child: ColorPicker(
                    pickerColor: noteColor,
                    onColorChanged: (color) {
                      setState(() {
                        noteColor = color;
                      });
                    })),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //use for language support text
    String changeAppTheme =
        AppLocalizations.of(context)?.change_app_theme ?? "Change App Theme";
    String changeTaskColor =
        AppLocalizations.of(context)?.change_task_color ?? "Change Task Color";
    String changeAppLanguage =
        AppLocalizations.of(context)?.change_app_language ??
            "Change Task Color";

    return Consumer<TaskAppDataNotifier>(
      builder: (context, notifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: notifier.darkTheme! ? dark : light,
          home: Scaffold(
              appBar: AppBar(
                leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      size: largeIcon,
                    )),
                backgroundColor: const Color(0XFF77a7f0),
                title: Text(
                  AppLocalizations.of(context)?.app_name ?? "App",
                  style: lPoppinsTextWhite,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              body: Container(
                padding: const EdgeInsets.only(left: 10, right: 10,top: 10),
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        _showColorDialog();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        height: 55,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: const Color(0XFFfceecb),
                            borderRadius: sBorderRadius),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Text(changeTaskColor,
                                  overflow: TextOverflow.ellipsis,
                                  style: mPoppinsTextBlack),
                            ),
                            Icon(
                              Icons.color_lens_rounded,
                              size: extraLargeIcon,
                              color: Color(notifier.taskColor),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Consumer<TaskAppDataNotifier>(
                      builder: (context, notifier, child) {
                        return Container(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: const Color(0XFFfceecb),
                              borderRadius: sBorderRadius),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(changeAppLanguage,
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              DropdownButton<String>(
                                  dropdownColor: Colors.white,
                                  isExpanded: true,
                                  value: notifier.appLanguageName ?? "en",
                                  items: dropDownLanguageList,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedLanguageName = value!;
                                      notifier.setLanguageName(value);
                                    });
                                  }),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        height: 55,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: const Color(0XFFfceecb),
                            borderRadius: sBorderRadius),
                        child: Consumer<TaskAppDataNotifier>(
                          builder: (context, notifier, child) {
                            return SwitchListTile(
                                title: Text(
                                  changeAppTheme,
                                  style: mPoppinsTextBlack,
                                ),
                                value: notifier.darkTheme!,
                                onChanged: (value) {
                                  notifier.toggleTheme();
                                });
                          },
                        )),
                  ],
                ),
              )),
        );
      },
    );
  }
}

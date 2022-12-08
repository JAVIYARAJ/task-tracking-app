import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/StateManagement/state_management.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

import '../AppTheme/app_theme.dart';


class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Color noteColor = Colors.deepOrange;

  Future _showColorDialog() {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            actions: [
              Consumer<ThemeNotifier>(
                builder: (context, notifier, child) {
                  return ElevatedButton(
                    child: Text(AppLocalizations.of(context)?.got_it ?? 'Got it'),
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
              style: GoogleFonts.poppins(fontSize: 25, color: Colors.black),
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

  var dropDownList = [
    DropdownMenuItem(
        value: "en",
        child: Card(
          elevation: 4,
          color: Colors.teal,
          child: Expanded(
            child: Text(
              "English",
              style: GoogleFonts.montserrat(fontSize: 25, color: Colors.black),
            ),
          ),
        )),
    DropdownMenuItem(
        value: "hi",
        child: Card(
          elevation: 4,
          color: Colors.teal,
          child: Text(
            "hindi",
            style: GoogleFonts.montserrat(fontSize: 25, color: Colors.black),
          ),
        )),
    DropdownMenuItem(
        value: "zh",
        child: Card(
          elevation: 4,
          color: Colors.teal,
          child: Text(
            "chines",
            style: GoogleFonts.montserrat(fontSize: 25, color: Colors.black),
          ),
        )),
    DropdownMenuItem(
        value: "ar",
        child: Card(
          elevation: 4,
          color: Colors.teal,
          child: Text(
            "Arabic",
            style: GoogleFonts.montserrat(fontSize: 25, color: Colors.black),
          ),
        )),
    DropdownMenuItem(
        value: "ml",
        child: Card(
          elevation: 4,
          color: Colors.teal,
          child: Text(
            "Malayalam",
            style: GoogleFonts.montserrat(fontSize: 25, color: Colors.black),
          ),
        )),
    DropdownMenuItem(
        value: "fr",
        child: Card(
          elevation: 4,
          color: Colors.teal,
          child: Text(
            "Frensh",
            style: GoogleFonts.montserrat(fontSize: 25, color: Colors.black),
          ),
        )),
  ];

  String selectedLanguageName="en";


  @override
  Widget build(BuildContext context) {

    String changeAppTheme=AppLocalizations.of(context)?.change_app_theme ?? "Change App Theme";
    String changeTaskColor=AppLocalizations.of(context)?.change_task_color ?? "Change Task Color";
    String changeAppLanguage=AppLocalizations.of(context)?.change_app_language ??"Change Task Color";


    return Consumer<ThemeNotifier>(
      builder: (context, notifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: notifier.darkTheme! ? dark : light,
          home: Scaffold(
              body: Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 40),
            height: double.infinity,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          size: 30,
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)?.settings ?? "Settings",
                      style: GoogleFonts.raleway(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Colors.grey,
                  height: 3,
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    _showColorDialog();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(changeTaskColor,
                            style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Icon(
                          Icons.color_lens_rounded,
                          size: 35,
                          color: Color(notifier.taskColor),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Consumer<ThemeNotifier>(
                  builder: (context,notifier,child){
                    return Container(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10)),
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
                              value:notifier.appLanguageName ?? "en",
                              items: dropDownList,
                              onChanged: (value) {
                                setState(() {
                                    selectedLanguageName=value!;
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
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10)),
                    child: Consumer<ThemeNotifier>(
                      builder: (context, notifier, child) {
                        return SwitchListTile(
                            title: Text(
                              changeAppTheme,
                              style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
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

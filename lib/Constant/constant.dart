import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

//font size
const smallTextSize = 12;
const mediumTextSize = 16;
const largeTextSize = 20;
const extraLargeTextSize = 25;

//font color
const textColorWhite = Colors.white;
const textColorBlack = Colors.black;

//font weight
const smallFontWeight = FontWeight.w600;
const mediumFontWeight = FontWeight.w900;
const largeFontWeight = FontWeight.bold;

//icon size and color
const smallIcon = 15.0;
const mediumIcon = 20.0;
const largeIcon = 25.0;
const extraLargeIcon = 40.0;

const iconWhite = Colors.white;
const iconBlack = Colors.black;

//google font with style
TextStyle sPoppinsTextBlack = GoogleFonts.poppins(
    fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black);
TextStyle mPoppinsTextBlack = GoogleFonts.poppins(
    fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black);
TextStyle lPoppinsTextBlack = GoogleFonts.poppins(
    fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black);

TextStyle taskGoogleFont = GoogleFonts.aBeeZee(
    fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold);
TextStyle taskDateAndTimeGoogleFont=GoogleFonts.nerkoOne(
    fontSize: 12,
    color: Colors.black,
    fontWeight:
    FontWeight.normal);

TextStyle sPoppinsTextWhite = GoogleFonts.poppins(
    fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white);
TextStyle mPoppinsTextWhite = GoogleFonts.poppins(
    fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white);
TextStyle lPoppinsTextWhite = GoogleFonts.poppins(
    fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white);

//border radius
BorderRadius sBorderRadius = BorderRadius.circular(10);
BorderRadius mBorderRadius = BorderRadius.circular(20);
BorderRadius lBorderRadius = BorderRadius.circular(25);
BorderRadius textFieldBorderRadius= BorderRadius.circular(15);

//navbar property

//drop down property
var dropDownFilterTask = [
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

List<DropdownMenuItem<String>> dropDownTaskCategory = [
  const DropdownMenuItem(
    value: "Home",
    child: Text("Home"),
  ),
  const DropdownMenuItem(
    value: "Education",
    child: Text("Education"),
  ),
  const DropdownMenuItem(
    value: "Exam",
    child: Text("Exam"),
  ),
  const DropdownMenuItem(
    value: "Festival",
    child: Text("Festival"),
  ),
  const DropdownMenuItem(
    value: "Others",
    child: Text("Others"),
  ),
];

var dropDownLanguageList = [
  DropdownMenuItem(
      value: "en",
      child: Card(
        elevation: 4,
        color:const Color(0XFF77a7f0),
        child: Text(
          "English",
          style: GoogleFonts.montserrat(fontSize: 25, color: Colors.black),
        ),
      )),
  DropdownMenuItem(
      value: "hi",
      child: Card(
        elevation: 4,
        color:const Color(0XFF77a7f0),
        child: Text(
          "hindi",
          style: GoogleFonts.montserrat(fontSize: 25, color: Colors.black),
        ),
      )),
  DropdownMenuItem(
      value: "zh",
      child: Card(
        elevation: 4,
        color:const Color(0XFF77a7f0),
        child: Text(
          "chines",
          style: GoogleFonts.montserrat(fontSize: 25, color: Colors.black),
        ),
      )),
  DropdownMenuItem(
      value: "ar",
      child: Card(
        elevation: 4,
        color:const Color(0XFF77a7f0),
        child: Text(
          "Arabic",
          style: GoogleFonts.montserrat(fontSize: 25, color: Colors.black),
        ),
      )),
  DropdownMenuItem(
      value: "ml",
      child: Card(
        elevation: 4,
        color:const Color(0XFF77a7f0),
        child: Text(
          "Malayalam",
          style: GoogleFonts.montserrat(fontSize: 25, color: Colors.black),
        ),
      )),
  DropdownMenuItem(
      value: "fr",
      child: Card(
        elevation: 4,
        color:const Color(0XFF77a7f0),
        child: Text(
          "French",
          style: GoogleFonts.montserrat(fontSize: 25, color: Colors.black),
        ),
      )),
];



List<DropdownMenuItem<String>> dropDownDocumentItems = [
  const DropdownMenuItem(
    value: "png",
    child: Text("Image"),
  ),
  const DropdownMenuItem(
    value: "pdf",
    child: Text("PDF"),
  ),
  const DropdownMenuItem(
    value: "docx",
    child: Text("Document"),
  ),
];

//map property

//date and time picker
Future<String> _showDateAndTimePicker(BuildContext context) async {
  DateTime initialDate = DateTime.now();
  DateTime firstDate = DateTime(2001);
  DateTime lastDate = DateTime(2025);

  DateTime? dateAndTime = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate);

  return DateFormat('yyyy-MM-dd - kk:mm').format(dateAndTime!);
}

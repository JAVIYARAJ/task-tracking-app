import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_settings/open_settings.dart';

class ReusableWidgets {
  //build a add and update task button
  static Widget buildButton(String buttonName) {
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

  static Widget buildErrorScreen(){
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/4_File Not Found.png",
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: 100,
          left: 30,
          child: FlatButton(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)),
            onPressed: () async{
              await OpenSettings.openMainSetting();
            },
            child: Text("Retry".toUpperCase(),style: GoogleFonts.poppins(),),
          ),
        )
      ],
    );
  }
}

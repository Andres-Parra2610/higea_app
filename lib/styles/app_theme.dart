

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme{

  static const int primaryColor = 0xff005CB9;
  static const int secondaryColor = 0xffE1251B;
  static const double horizontalPadding = 30;

  static final ThemeData lightTheme = ThemeData(

    fontFamily: GoogleFonts.poppins().fontFamily,

    primaryColor: const Color(primaryColor),
    colorScheme: const ColorScheme.light(
      primary: Color(primaryColor)
    ),

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.grey[600]),
      floatingLabelStyle: const TextStyle(color: Color(primaryColor)),
      border: const OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius:  BorderRadius.circular(10)
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(primaryColor)),
        borderRadius:  BorderRadius.circular(10)
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(secondaryColor)),
        borderRadius:  BorderRadius.circular(10)
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(secondaryColor)),
        borderRadius:  BorderRadius.circular(10)
      ),
    ),

    textTheme: const TextTheme(
      headline5: TextStyle(
        fontWeight: FontWeight.w900,
        color: Colors.black
      ),
      headline6: TextStyle(
        fontWeight: FontWeight.bold
      ),
      subtitle2: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold
      )

    )

    
  );

  //GradientDecoration
  static BoxDecoration BoxGradient({double fOpacity = 1, double sOpacity = 0.6}) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          const Color(AppTheme.primaryColor).withOpacity(fOpacity), 
          const Color(AppTheme.primaryColor).withOpacity(sOpacity)
        ]
      )
    );
  }
}
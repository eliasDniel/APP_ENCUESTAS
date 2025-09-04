


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


const colorSeed = Color(0xff424CB8);
const scaffoldBackgroundColor = Color(0xFFF8F7F7);

class AppTheme {

  ThemeData getTheme() => ThemeData(
    ///* General
    useMaterial3: true,
    colorSchemeSeed: colorSeed,

    ///* Texts
    textTheme: TextTheme(
      titleLarge: GoogleFonts.montserratAlternates()
        .copyWith( fontSize: 40, fontWeight: FontWeight.bold ),
      titleMedium: GoogleFonts.montserratAlternates()
        .copyWith( fontSize: 30, fontWeight: FontWeight.bold ),
      titleSmall: GoogleFonts.montserratAlternates()
        .copyWith( fontSize: 20 ),
      

      bodyLarge: GoogleFonts.montserratAlternates()
        .copyWith( ),
      bodyMedium: GoogleFonts.montserratAlternates()
        .copyWith(  ),
      bodySmall: GoogleFonts.montserratAlternates()
        .copyWith( ),

      displayLarge: GoogleFonts.montserratAlternates()
        .copyWith( fontWeight: FontWeight.bold ),
      displayMedium: GoogleFonts.montserratAlternates()
        .copyWith( fontWeight: FontWeight.bold ),
      displaySmall: GoogleFonts.montserratAlternates()
        .copyWith( fontWeight: FontWeight.bold ),


labelLarge: GoogleFonts.montserratAlternates()
        .copyWith(  fontWeight: FontWeight.bold ),
      labelMedium: GoogleFonts.montserratAlternates()
        .copyWith(  fontWeight: FontWeight.bold ),
      labelSmall: GoogleFonts.montserratAlternates()
        .copyWith(  fontWeight: FontWeight.bold ),
      
    ),

    ///* Scaffold Background Color
    scaffoldBackgroundColor: scaffoldBackgroundColor,
    

    ///* Buttons
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStatePropertyAll(
          GoogleFonts.montserratAlternates()
            .copyWith(fontWeight: FontWeight.w700)
          )
      )
    ),

    ///* AppBar
    appBarTheme: AppBarTheme(
      color: scaffoldBackgroundColor,
      titleTextStyle: GoogleFonts.montserratAlternates()
        .copyWith( fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black ),
    )
  );

}
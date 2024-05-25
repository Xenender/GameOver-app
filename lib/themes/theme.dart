import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(

    textTheme: TextTheme(
      bodyLarge: GoogleFonts.montserrat(textStyle: TextStyle()),
          bodyMedium: GoogleFonts.montserrat(textStyle: TextStyle()),
      bodySmall: GoogleFonts.montserrat(textStyle: TextStyle()),
      displayLarge: GoogleFonts.montserrat(textStyle: TextStyle()),
      displayMedium: GoogleFonts.montserrat(textStyle: TextStyle()),
      displaySmall: GoogleFonts.montserrat(textStyle: TextStyle()),
      headlineLarge: GoogleFonts.montserrat(textStyle: TextStyle()),
      headlineMedium: GoogleFonts.montserrat(textStyle: TextStyle()),
      headlineSmall: GoogleFonts.montserrat(textStyle: TextStyle()),
      titleLarge: GoogleFonts.montserrat(textStyle: TextStyle()),
      titleMedium: GoogleFonts.montserrat(textStyle: TextStyle()),
      titleSmall: GoogleFonts.montserrat(textStyle: TextStyle()),
      labelLarge: GoogleFonts.montserrat(textStyle: TextStyle()),
      labelMedium: GoogleFonts.montserrat(textStyle: TextStyle()),
      labelSmall: GoogleFonts.montserrat(textStyle: TextStyle()),


    ),
    colorScheme: ColorScheme(

      //primary: Color(0xFFF2B872),             // Couleur principale
      primary: Color(0xFFB379D9),
      onPrimary: Colors.white,          // Couleur du texte sur la couleur principale
      //secondary: Color(0xFFF27B50),          // Couleur secondaire
      secondary: Color(0xFFBF656D),
      onSecondary: Colors.white,
      tertiary: Color(0xFFF2CFC2),
      onTertiary: Colors.white,




      background: Colors.white,        // Couleur d'arrière-plan
      brightness: Brightness.light,     // Luminosité (light)// Couleur du texte sur la couleur secondaire
      error: Colors.red,                // Couleur en cas d'erreur
      onError: Colors.white,            // Couleur du texte en cas d'erreur
      onBackground: Colors.black,       // Couleur du texte sur l'arrière-plan
      surface: Colors.white,             // Couleur de surface
      onSurface: Colors.black,          // Couleur du texte sur la surface
    )
,
    buttonTheme: ButtonThemeData(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Ajustez la valeur pour définir la rondeur de la bordure
          ),


    ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(

          backgroundColor: Color(0xFF1AC5CA),
          textStyle: GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white),color: Colors.white),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            // Ajustez la valeur pour définir la rondeur de la bordure
          ),

        )
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Ajustez la valeur pour définir la rondeur de la bordure
        ),

  )


  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.blue,
    textTheme: TextTheme(

      // ...
    ),
  );
}

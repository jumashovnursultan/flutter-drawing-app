import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      colorScheme: ColorScheme.dark(
        primary: Color(0xFF6200EE),
        secondary: Color(0xFF03DAC6),

        background: Colors.transparent,
        error: Colors.red,
      ),

      brightness: Brightness.dark,

      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: UnderlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.only(left: -4, bottom: 12),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF94929B), width: 0.5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF94929B), width: 0.5),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF94929B), width: 0.5),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF94929B), width: 0.5),
        ),
        filled: true,
        fillColor: Colors.transparent,
      ),

      textTheme: GoogleFonts.robotoTextTheme(
        TextTheme(
          displayLarge: GoogleFonts.pressStart2p(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          displayMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }
}

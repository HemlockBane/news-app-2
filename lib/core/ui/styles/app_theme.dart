import 'package:flutter/material.dart';

class AppTheme {
  ThemeData get lightTheme {
    final ThemeData baseTheme = ThemeData.light();
    return baseTheme.copyWith(
      appBarTheme: const AppBarTheme(
        color: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white
        )

      )
    );
  }
}

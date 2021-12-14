import 'package:flutter/material.dart';
import 'package:news_app_2/core/app_theme.dart';
import 'package:news_app_2/ui/screens/articles_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme().lightTheme,
      home: const ArticlesScreen(),
    );
  }
}

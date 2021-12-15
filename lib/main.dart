import 'package:flutter/material.dart';
import 'package:news_app_2/app/article_home/screens/articles_home_screen.dart';
import 'package:news_app_2/core/app_routes.dart';
import 'package:news_app_2/core/app_theme.dart';

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
      onGenerateRoute: AppRoutes.generateRouteWithSettings,
      routes: AppRoutes.buildRouteMap()
    );
  }
}

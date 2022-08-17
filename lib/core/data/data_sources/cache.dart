import 'dart:developer';

import 'package:news_app_2/core/data/models/category.dart';

class Cache {
  static final Cache _instance = Cache._internal();

  factory Cache() => _instance;

  Cache._internal();

  List<Category> _categories = [];
  List<String> _difficultyLevels = [];

  bool isEmpty() {
    return (_categories.isEmpty && _difficultyLevels.isEmpty);
  }

  void printAll() {
    log("cached categories: ${_categories.toString()}");
    log("cached difficulty levels: ${_difficultyLevels.toString()}");
  }

  Future<void> saveCategories(List<Category> categories) {
    return Future.microtask(() => _categories = categories);
  }

  Future<void> saveDifficultyLevels(List<String> difficultyLevels) {
    return Future.microtask(() => _difficultyLevels = difficultyLevels);
  }

  Future<List<Category>?> getCategories() => Future.microtask(() => _categories);
  Future<List<String>?> getDifficultyLevels() =>
      Future.microtask(() => _difficultyLevels);
}

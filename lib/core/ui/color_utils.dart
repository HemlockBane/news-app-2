  import 'package:flutter/material.dart';
import 'package:news_app_2/core/ui/styles/app_colors.dart';

Color getColor(String level) {
    switch (level.toLowerCase()) {
      case "advanced":
        return AppColors.advancedDarkRed;
      case "intermediate":
        return AppColors.intermediateDarkYellow;
      default:
        return AppColors.beginnerDarkGreen;
    }
  }

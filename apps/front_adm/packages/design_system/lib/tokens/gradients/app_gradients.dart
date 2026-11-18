import 'package:flutter/material.dart';
import '../colors/app_colors.dart';

class AppGradients {
  AppGradients._();

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.primaryBase, AppColors.primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

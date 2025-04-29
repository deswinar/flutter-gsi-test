import 'package:flutter/material.dart';
import 'app_text_styles.dart';

final ThemeData appTheme = ThemeData(
  textTheme: const TextTheme(
    headlineMedium: AppTextStyles.heading,
    bodyMedium: AppTextStyles.body,
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  useMaterial3: true,
);

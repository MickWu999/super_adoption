import 'package:flutter/material.dart';
import 'package:super_adoption/core/theme/app_theme.dart';
import 'package:super_adoption/features/start/ui/start_screen.dart';

void main() {
  runApp(const SuperAdoptionApp());
}


class SuperAdoptionApp extends StatelessWidget {
  const SuperAdoptionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '超級認養',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const StartScreen(),
    );
  }
}

import 'package:flutter/material.dart';

class ErrorFallbackCard extends StatelessWidget {
  const ErrorFallbackCard({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/error_fallback.png', fit: BoxFit.cover),
        ],
      ),
    );
  }
}

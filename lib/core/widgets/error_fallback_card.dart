import 'package:flutter/material.dart';
import 'package:super_adoption/core/extension/responsive_extension.dart';

class ErrorFallbackCard extends StatelessWidget {
  const ErrorFallbackCard({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220.t,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.tr)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/error_fallback.png', fit: BoxFit.cover),
        ],
      ),
    );
  }
}

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
          // Positioned(
          //   left: 16,
          //   right: 16,
          //   bottom: 16,
          //   child: Text(
          //     message ?? '暫時找不到毛孩資料',
          //     textAlign: TextAlign.center,
          //     style: theme.textTheme.titleSmall?.copyWith(
          //       color: Colors.black,
          //       // fontWeight: FontWeight.w800,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

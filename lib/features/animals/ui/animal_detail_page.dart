
import 'package:flutter/material.dart';

class AnimalDetailScreen extends StatelessWidget {
  const AnimalDetailScreen({
    super.key,
    required this.animalId,
  });

  final String animalId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('毛孩詳情')),
      body: Center(child: Text('animalId: $animalId')),
    );
  }
}
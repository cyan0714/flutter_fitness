import 'package:flutter/material.dart';

class ShoulderPage extends StatelessWidget {
  const ShoulderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('肩部训练'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Text(
          '肩部训练',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}


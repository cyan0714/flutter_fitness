import 'package:flutter/material.dart';

class ChestPage extends StatelessWidget {
  const ChestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('胸部训练'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Text(
          '胸部训练',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}


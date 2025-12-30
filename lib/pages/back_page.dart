import 'package:flutter/material.dart';

class BackPage extends StatelessWidget {
  const BackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('背部训练'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Text(
          '背部训练',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';

class Discover extends StatelessWidget {
  const Discover({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Discover',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Discover'),
        ),
        body: const Center(
          child: Text('Discover'),
        ),
      ),
    );
  }
}

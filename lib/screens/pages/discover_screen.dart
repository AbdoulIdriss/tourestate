import 'package:flutter/material.dart';

class DiscoverScreen extends StatelessWidget {

  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: const Text(
        'Discover Content Screen',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {

  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: const Text(
        'Map Content Screen',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}
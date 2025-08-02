import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      height: deviceHeight * 0.35,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          // IMPORTANT: Replace this with your own high-quality image asset
          image: NetworkImage('https://i.pinimg.com/736x/0b/30/ab/0b30aba482d289418f887076b8ecae94.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:estate/screens/auth_screen.dart';
import 'package:estate/widgets/navigation_bar.dart';

import 'package:estate/screens/pages/home_content.dart';
import 'package:estate/screens/pages/discover_screen.dart';
import 'package:estate/screens/pages/map_screen.dart';
import 'package:estate/screens/pages/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    HomeContentScreen(),
    DiscoverScreen(),
    MapScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.logout),
        //     onPressed: () {
        //       FirebaseAuth.instance.signOut();
        //       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const AuthScreen()));
        //     },
        //   ),
        // ],
      ),
      body: 
      _screens[_selectedIndex],
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

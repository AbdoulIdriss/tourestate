import 'package:estate/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:estate/screens/auth_screen.dart';
import 'package:estate/widgets/navigation_bar.dart';

import 'package:estate/screens/pages/home_content.dart';
import 'package:estate/screens/pages/favorite_screen.dart';
import 'package:estate/screens/pages/map_screen.dart';
import 'package:estate/screens/pages/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController(); // Moved controller here

  // Use a nullable type for the screen list, then populate it in initState
  List<Widget>? _screens;

  @override
  void initState() {
    super.initState();
    _screens = <Widget>[
      HomeContentScreen(searchController: _searchController), // Pass controller
      const FavoriteScreen(),
      const MapScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose the controller when HomeScreen is disposed
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Titles corresponding to each screen
  static const List<String> _screenTitles = <String>[
    'Home', // HomeContentScreen will have the search bar instead of a text title
    'Favorites',
    'Map',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          // User is logged in, show the main content
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 30,
              title: _selectedIndex == 0
                  ? null
                  : Text(
                      _screenTitles[_selectedIndex],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              bottom: _selectedIndex == 0
                  ? PreferredSize(
                      preferredSize: const Size.fromHeight(60.0), // Adjust height if necessary
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding for the Row
                        child: Row(
                          children: [
                            Expanded( // Makes the search bar take available space
                              child: CustomSearchBar(
                                controller: _searchController,
                              ),
                            ),
                            const SizedBox(width: 2.0), // Space between search bar and button
                            IconButton(
                              icon: const Icon(Icons.filter_list),
                              iconSize: 40, // Filter icon
                              onPressed: () {
                                print('Filter button pressed!');
                              },
                              tooltip: 'Filter', // Optional tooltip
                            ),
                          ],
                        ),
                      ),
                    )
                  : null,
            ),
            body: _screens![_selectedIndex], // Use _screens! because it's initialized in initState
            bottomNavigationBar: CustomNavigationBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          );
        } else {
          // User is NOT logged in, show the authentication screen
          return const AuthScreen();
        }
      },
    );
  }
}

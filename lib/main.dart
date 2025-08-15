import 'package:estate/providers/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:estate/services/debug_utility.dart';

import 'package:estate/screens/pages/home.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  
);
  
  // Debug: Check and fix properties
  await DebugUtility.checkAndFixProperties();
  
  runApp(
    ChangeNotifierProvider( // Wrap with ChangeNotifierProvider
      create: (context) => FavoritesProvider(), // Create an instance of your provider
    child : const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Real Estate App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
   }
  
}
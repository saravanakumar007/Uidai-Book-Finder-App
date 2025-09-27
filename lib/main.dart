import 'package:flutter/material.dart';
import 'package:uidai/presentation/views/book_search_screen.dart';
import 'package:uidai/presentation/views/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: BookCoversSplashScreen(),
      routes: {
        '/home': (context) => BookSearchScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
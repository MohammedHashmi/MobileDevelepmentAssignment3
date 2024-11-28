import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(FoodOrderingApp());
}

class FoodOrderingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Ordering App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}
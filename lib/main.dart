import 'package:flutter/material.dart';
import 'package:trackapplication/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  //initialize the hive
  await Hive.initFlutter();

  //open a box
  await Hive.openBox("Habit_Database");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green, // Set the primary theme color to green
      ),
      home: const HomePage(),
    ); // MaterialApp
  }
}

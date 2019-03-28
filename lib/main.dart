import 'package:flutter/material.dart';
import 'taskScreen.dart';
import 'addTaskScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => TaskScreen(),
        '/add': (context) => AddTaskScreen()
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:send_data_to_api/todo_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Send Data To Api',
    debugShowCheckedModeBanner: false,
      home: const ToDoList(),
    );
  }
}

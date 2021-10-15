import 'package:flutter/material.dart';

class Task {
  String? id;
  String title;
  String description;
  DateTime dueDate;
  bool completed;
  Task({required this.dueDate,required this.description,
    required this.title,required this.completed,this.id});

  factory Task.fromJson(Map<String,dynamic> json)=>
      Task(
          id: json['_id'],
          dueDate: DateTime.parse(json['due']) ,
          description: json['description'],
          title: json['name'], completed: json['completed']);

  Map<String,dynamic> toJson(){
    Map<String,dynamic> json = Map<String,dynamic>();
    if(this.id!=null) json['_id'] = this.id;
    json['due'] = this.dueDate.toIso8601String();
    json['description'] = this.description;
    json['name'] = this.title;
    json['completed'] = this.completed;
    return json;
  }
}
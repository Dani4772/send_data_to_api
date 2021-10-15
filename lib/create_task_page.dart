import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model_todo.dart';

class ManageTask extends StatefulWidget {
  final Task? task;
  const ManageTask({Key? key,this.task}) : super(key: key);

  @override
  _ManageTaskState createState() => _ManageTaskState();
}

class _ManageTaskState extends State<ManageTask> {
  var title = TextEditingController();
  var description = TextEditingController();
  DateTime? dueDate;
  var formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    if(widget.task!=null){
      isEditMode = true;
      title.text = widget.task!.title;
      description.text = widget.task!.description;
      dueDate = widget.task!.dueDate;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? "Update Task" : "Create Task"),
      ),
      body: Form(
        key: formKey,
        autovalidateMode: autoValidateMode,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Title', border: OutlineInputBorder()),
                controller: title,
                validator: (String? value) {
                  if (value!.isEmpty)
                    return "This field is required";
                  else
                    return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Description', border: OutlineInputBorder()),
                controller: description,
                validator: (String? value) {
                  if (value!.isEmpty)
                    return "This field is required";
                  else
                    return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(3000));
                  print(selectedDate);
                  if (selectedDate != null) {
                    dueDate = selectedDate;
                    setState(() {});
                  }
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey)
                  ),
                  child: Center(child: Text(dueDate==null  ? "Select Date Time" : dueDate!.toIso8601String())),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      if(dueDate == null) {
                        ScaffoldMessenger.of(context).
                        showSnackBar(SnackBar(content: Text("You must select due date")));
                      } else {
                        //


                        if(isEditMode){
                          showDialog(context: context, builder: (i){
                            return AlertDialog(
                              title: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator()),
                              content: Text("Updating"),
                            );
                          });
                          http.patch(Uri.parse("http://46.101.81.185:9500/todo"),
                              headers: <String, String>{
                                'Content-Type': 'application/json; charset=UTF-8',
                              },
                              body: jsonEncode(Task(
                                  id: widget.task!.id,
                                  dueDate: dueDate!,
                                  description: description.text,
                                  title: title.text,
                                  completed: false).toJson()));
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                        else{
                              showDialog(context: context, builder: (i){
                              return AlertDialog(
                              title: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator()),
                              content: Text("Creating"),
                              );
                              });
                              await http.post(Uri.parse("http://46.101.81.185:9500/todo"),
                              headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                              },
                              body: jsonEncode(Task(
                              dueDate: dueDate!,
                              description: description.text,
                              title: title.text,
                              completed: false).toJson())
                              );
                              Navigator.pop(context);
                              Navigator.pop(context);
                              }


                        // pop
                      }
                    } else {
                      setState(() {
                        autoValidateMode = AutovalidateMode.always;
                      });
                    }
                  },
                  child: Text(isEditMode ? "Update" : "Create"))
            ],
          ),
        ),
      ),
    );
  }
}

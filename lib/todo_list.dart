import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:send_data_to_api/create_task_page.dart';

import 'model_todo.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  Future<List<Task>?>? apiCall;
  var Refreshkey = GlobalKey<RefreshIndicatorState>();


  Future<List<Task>?> loadDataFromApi() async {
    try {
      Response res = await http.get(Uri.parse("http://46.101.81.185:9500/todo"));
      print(res.body);
      print("this was called");
      if (res.statusCode == 200) {
        List<Map<String,dynamic>> decodedJson =jsonDecode(res.body).cast<Map<String, dynamic>>();
        return decodedJson.map((e) => Task.fromJson(e)).toList();
      } else {

      }
    } catch(e){
      print(e);
    }

  }

  @override
  void initState() {
    super.initState();
    apiCall= loadDataFromApi();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          floatingActionButton: FloatingActionButton  (
            child: Icon(Icons.add),
              onPressed: () async{
                Task? response= await  Navigator.push(context, MaterialPageRoute(builder: (context)=>ManageTask()));
                  Refreshkey.currentState!.show();
                  print("user is back from create task page");
              }
              ),

      appBar: AppBar(title: Text('ToDo List'),),

      body: FutureBuilder(
        future: apiCall,
        builder: (context, AsyncSnapshot<List<Task>?> snapshot){
          if(snapshot.hasData){
            return RefreshIndicator(
              key: Refreshkey,
              onRefresh: () async {
                apiCall= loadDataFromApi();
                setState(() {});
              },
              child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder:(context, index){
                    return ListTile(

                      onTap: () async{
                        Task? updatedTask= await  Navigator.push(context, MaterialPageRoute(builder: (context)=> ManageTask(task: snapshot.data![index],) ));
                        if(updatedTask!=null){
                          Refreshkey.currentState!.show();
                        }
                      },
                      title: Text(snapshot.data![index].description),
                      subtitle: Text(snapshot.data![index].title),
                      trailing: IconButton(icon: Icon(Icons.delete),
                        onPressed: () async {
                          showDialog(context: context, builder: (i){
                            return AlertDialog(
                              title: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator()),
                              content: Text("Deleting"),
                            );
                          });
                          await http.delete(Uri.parse("http://46.101.81.185:9500/todo/${snapshot.data![index].id}"),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },);
                          Navigator.pop(context);
                          Refreshkey.currentState!.show();
                        },),
                    );
                  }
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

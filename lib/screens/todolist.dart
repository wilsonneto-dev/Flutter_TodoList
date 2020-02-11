import 'package:flutter/material.dart';
import 'package:to_do/model/todo.dart';
import 'package:to_do/util/dbhelper.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  DbHelper helper = DbHelper();
  List<Todo> todos;
  int count = 0;
  
  @override
  Widget build(BuildContext context) {
    if(todos == null) {
      todos = List<Todo>();
      getData();
    }

    return Scaffold(
      body: todoListItems(),
      floatingActionButton: ,
    );
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final todosFuture = helper.getTodos();
      todosFuture.then((result){
        count = result.length;
        setState((){
          todos = result;
          count = count;
        });
      });
    });
  }
}
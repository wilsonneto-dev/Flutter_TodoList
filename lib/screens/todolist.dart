import 'package:flutter/material.dart';
import 'package:to_do/model/todo.dart';
import 'package:to_do/util/dbhelper.dart';
import 'package:to_do/screens/tododetail.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add),
        tooltip: "Add To-Do",
      ),
    );
  }

  ListView todoListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          margin: EdgeInsets.all(5),
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getColor(this.todos[position].priority),
              child: Text(this.todos[position].id.toString()),
            ),
            title: Text(this.todos[position].title),
            subtitle: Text(this.todos[position].date),
            /* trailing: Icon(Icons.track_changes), */
            onTap: () {
              debugPrint("taped in ${this.todos[position].title}");
              navigateToDetail(this.todos[position]);
            },
          )
        );
      }
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

  Color getColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.orange;
        break;
      case 2:
      default:
        return Colors.green;
        break;      
    }
  }

  void navigateToDetail(Todo todo) async {
    bool result = await Navigator.push(context, MaterialPageRoute(
      builder: (ctx) => TodoDetail(todo)
    ));
    if(result == true) {
      getData();
    }
  }
}
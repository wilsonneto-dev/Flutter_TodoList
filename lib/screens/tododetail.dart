import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:to_do/model/todo.dart';
import 'package:to_do/util/dbhelper.dart';
import 'package:intl/intl.dart';

class TodoDetail extends StatefulWidget {
  final Todo todo;

  TodoDetail(this.todo);

  @override
  State<StatefulWidget> createState() => TodoDetailState(todo);
}

DbHelper helper = DbHelper();
final List<String> menuOptions = const <String> [
  'Save Todo & Back',
  'Delete Todo',
  'Back to List'
];

const mnuSave = 'Save Todo & Back';
const mnuDelet = 'Delete Todo';
const mnuBack = 'Back to List';

class TodoDetailState extends State {
  Todo todo;
  TodoDetailState(this.todo);

  final _priorities = ["High", "Medium", "Low"];
  String _priority = "Low";

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    descriptionController.text = todo.description;
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(todo.title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) => select(value),
            itemBuilder: (BuildContext context) {
              return menuOptions.map(
                (String option) => PopupMenuItem<String>(
                  value: option, 
                  child: Text(option),
                )
              ).toList();
            },
          ),
        ],
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
          Navigator.of(context).pop();
        },),
      ),
      body: ListView(children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              
              Padding( padding: EdgeInsets.only(top: 10),child: TextField(
                controller: titleController,
                style: textStyle,
                onChanged: (_) => this.updateTitle(),
                decoration: InputDecoration(
                    labelText: "Title",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              )),
              Padding( padding: EdgeInsets.only(top: 10),child: TextField(
                controller: descriptionController,
                onChanged: (_) => this.updateDescription(),
                style: textStyle,
                decoration: InputDecoration(
                    labelText: "Decsription",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              )),
              Padding( padding: EdgeInsets.only(top: 10),child: DropdownButton<String>(
                items: _priorities.map((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList(),
                style: textStyle,
                value: retrievePriority(todo.priority),
                onChanged: (String value) {
                  updatePriority(value);
                },
              ))
            ],
          ))
      ],) 
      ,
    );
  }

  void save() {
    todo.date = new DateFormat.yMd().format(DateTime.now());
    if(todo.id != null) {
      helper.updateTodo(todo);
    } else {
      helper.insertTodo(todo);
    }
    Navigator.of(context).pop();
  }

  Future<void> select (String value) async {
    int result;

    switch (value) {
      case mnuSave:
        save();
        break;
      case mnuDelet:
        Navigator.of(context).pop();
        if(todo.id == null) {
          return;
        }
        result = await helper.deleteTodo(todo.id);
        if(result != 0) {
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delete Todo"),
            content: Text("The Todo has been deleted"),
          );
          showDialog(context: context, builder: (_) => alertDialog);
        }
        break;
      case mnuBack:
        Navigator.of(context).pop();
        break;
      default:
        break;
    }
  }

  void updatePriority(String value) {
    switch (value) {
      case "High":
        todo.priority = 1;
        break;
      case "Medium":
        todo.priority = 2;
        break;
      case "Low":
        todo.priority = 3;
        break;
      default:
    }
    setState(() {
      _priority = value;
    });
  }

  String retrievePriority(int value) {
    return _priorities[value -1];
  }

  void updateTitle() {
    todo.title = titleController.text;
  }

  void updateDescription() {
    todo.description = descriptionController.text;
  }

}

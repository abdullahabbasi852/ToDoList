import 'package:flutter/material.dart';
import 'package:todolist_app/models/todo.dart';
import 'package:todolist_app/services/todo_service.dart';

class TodosByCategory extends StatefulWidget {
  final String category;

  TodosByCategory({this.category});

  @override
  _TodosByCategoryState createState() => _TodosByCategoryState();
}

class _TodosByCategoryState extends State<TodosByCategory> {
  List<Todo> _todoList = List<Todo>();
  TodoService _todoService = TodoService();

  @override
  void initState() {
    super.initState();
    getTodosByCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getTodosByCategories() async {
    _todoList = List<Todo>();
    var todos = await _todoService.readTodosByCategory(this.widget.category);
    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.todoDate = todo['todoDate'];

        _todoList.add(model);
      });
    });
  }

  deleteAlertDialog(BuildContext context, todoId) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () => Navigator.pop(context),
    );
    Widget continueButton = FlatButton(
      child: Text("Delete", style: TextStyle(color: Colors.red),),
      onPressed:  () async{
        var result = await _todoService.deleteTodo(todoId);
        if (result > 0) {
          Navigator.pop(context);
          getTodosByCategories();
          _showSuccessSnackBar(Text('Deleted'));
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Task"),
      content: Text("Do you like to delete this item?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(title: Text(this.widget.category)),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: _todoList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        elevation: 8,
                        child: ListTile(
                          onTap: (){},
                          onLongPress: (){
                            deleteAlertDialog(context, _todoList[index].id);
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[Text(_todoList[index].title)],
                          ),
                          subtitle: Text(_todoList[index].description),
                          trailing: Text(_todoList[index].todoDate),
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}

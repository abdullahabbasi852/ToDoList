import 'package:todolist_app/models/todo.dart';
import 'package:todolist_app/repositories/repository.dart';

class TodoService {
  Repository _repository;

  TodoService() {
    _repository = Repository();
  }

  // create todos
  saveTodo(Todo todo) async {
    return await _repository.insertData('todos', todo.todoMap());
  }

  // read todos
  readTodos() async {
    return await _repository.readData('todos');
  }

  // read todos by category
  readTodosByCategory(category) async {
    return await _repository.readDataByColumnName(
        'todos', 'category', category);
  }

  deleteTodo(todoId) async{
    return await _repository.deleteData('todos', todoId);
  }

}

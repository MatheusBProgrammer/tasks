import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TodoListStorage {
  final String _key = 'todoList';
  late SharedPreferences _prefs;

  TodoListStorage() {
    initPrefs();
  }

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<Map<String, dynamic>>> loadTodoList() async {
    final todoList = _prefs.getStringList(_key) ?? [];
    return todoList
        .map((task) => Map<String, dynamic>.from(
        task.isNotEmpty ? Map<String, dynamic>.from(jsonDecode(task)) : {}))
        .toList();
  }

  Future<void> saveTodoList(List<Map<String, dynamic>> todo) async {
    final todoList = todo.map((task) => jsonEncode(task)).toList();
    await _prefs.setStringList(_key, todoList);
  }
}

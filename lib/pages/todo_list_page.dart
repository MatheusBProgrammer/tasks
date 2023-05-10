import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tarefas/widgets/todo_list_item.dart';
import '../repositories/todo_repository.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();

  List<Map<String, dynamic>> todo = [];
  Map<String, dynamic>? removedTask;
  int? removedTaskIndex;

  late TodoListStorage _storage;

  @override
  void initState() {
    super.initState();
    _storage = TodoListStorage();
    _loadTodoList();
  }

  Future<void> _loadTodoList() async {
    await _storage.initPrefs();
    final todoList = await _storage.loadTodoList();
    setState(() {
      todo = todoList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 150),
              Text(
                'Lista de Tarefas',
                style: TextStyle(fontSize: 26),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: TextField(
                      controller: todoController,
                      onChanged: (text) {
                        if (text.startsWith(' ')) {
                          todoController.text = text.trimLeft();
                          todoController.selection = TextSelection.fromPosition(
                            TextPosition(offset: todoController.text.length),
                          );
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adicione uma tarefa',
                        hintText: 'Ex: Tomar café da manhã',
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff00d7f3),
                      fixedSize: Size(55, 58),
                    ),
                    onPressed: () {
                      String text = todoController.text;
                      String formattedDate =
                          DateFormat('dd/MM/yyyy').format(DateTime.now());
                      setState(() {
                        if (todoController.text != '') {
                          todo.add({'title': text, 'date': formattedDate});
                          todoController.clear();
                          _saveTodoList();
                        }
                      });
                    },
                    child: Icon(
                      Icons.add,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (int index = 0; index < todo.length; index++)
                      TodoListItem(
                        title: todo[index]['title'],
                        date: todo[index]['date'],
                        onDelete: (index) => onDelete(index),
                        index: index,
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child:
                          Text('Você possui ${todo.length} tarefas pendentes')),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff00d7f3),
                      fixedSize: Size(110, 50),
                    ),
                    onPressed: showDeleteTodosConfirmationDialog,
                    child: Text('Limpar tudo'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDeleteTodosConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar tudo?'),
        content: Text('Você tem certeza que deseja apagar todas as tarefas?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Color(0xff00d7f3)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                todo.clear();
                _saveTodoList();
              });
            },
            child: Text(
              'Limpar tudo',
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }

  void onDelete(int index) {
    removedTask = todo[index];
    removedTaskIndex = index;
    setState(() {
      todo.removeAt(index);
      _saveTodoList();
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${removedTask!['title']} foi removida com sucesso!',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              todo.insert(removedTaskIndex!, removedTask!);
              _saveTodoList();
            });
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Future<void> _saveTodoList() async {
    await _storage.saveTodoList(todo);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem(
      {Key? key,
      required this.title,
      required this.date,
      required this.onDelete,
      required this.index})
      : super(key: key);

  final String title;
  final String date;
  final void Function(int index) onDelete;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        //Define a proporção do IconSlideAction
        actionExtentRatio: 0.2,
        // Define a ação que aparecerá quando o item for arrastado para a esquerda
        actionPane: SlidableStrechActionPane(),
        // Define a ação que aparecerá quando o item for arrastado para a direita
        secondaryActions: [
          IconSlideAction(
            caption: 'Editar',
            color: Colors.blue,
            icon: Icons.edit,
            onTap: () {
              //Lógica para editar o item
            },
          ),
          // Define a ação de exclusão
          IconSlideAction(
            caption: 'Excluir',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              //Lógica para excluir o item
              onDelete(index);
            },
          ),
        ],
        // Define o conteúdo do item, que é o que será arrastado
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[100],
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

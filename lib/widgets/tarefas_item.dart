import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/tarefas.dart';

class TarefasItens extends StatelessWidget {
  TarefasItens({super.key, required this.tarefa, required this.onDelete, required this.onEdit});

  final Tarefa tarefa;
  final Function(Tarefa) onDelete;
  final Function(Tarefa) onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => onDelete(tarefa),
                backgroundColor: Color(0xffb00020),
                autoClose: true,
                icon: Icons.delete,
                foregroundColor: Colors.white,
                spacing: 0,
              ),
              SlidableAction(
                onPressed: (context) => onEdit(tarefa),
                backgroundColor: Color(0xff0086c3),
                autoClose: true,
                icon: Icons.edit,
                foregroundColor: Colors.white,
                spacing: 0,
              ),
              SlidableAction(
                onPressed: (context) => onEdit(tarefa),
                backgroundColor: Color(0xff248232),
                autoClose: true,
                icon: Icons.check,
                foregroundColor: Colors.white,
                spacing: 0,
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: 60),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color(0xff2d2d2d),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month, color: Colors.grey, size: 14,),
                    SizedBox(width: 2,),
                    Text(
                      DateFormat('dd/MM/yyyy').format(tarefa.dateTime),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(width: 5,),
                    Icon(Icons.access_time, color: Colors.grey, size: 14,),
                    SizedBox(width: 2,),
                    Text(DateFormat('HH:mm').format(tarefa.dateTime), style: TextStyle(color: Colors.grey, fontSize: 12),),
                  ],
                ),
               SizedBox(height: 5,),
                Text(
                  tarefa.titulo,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

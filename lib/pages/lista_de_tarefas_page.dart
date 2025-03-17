import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/models/tarefas.dart';
import '../widgets/tarefas_item.dart';
import '../repositories/todo_repository.dart';

class ListaTarefas extends StatefulWidget {
  ListaTarefas({super.key});

  @override
  State<ListaTarefas> createState() => _ListaTarefasState();
}

class _ListaTarefasState extends State<ListaTarefas> {
  final TextEditingController tarefaController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Tarefa> tarefas = [];
  List<Tarefa> tarefasConcluidas = [];

  Tarefa? deletedTarefa;
  int? deletedTarefaPos;

  String? errorText;

  @override
  void initState() {
    super.initState();
    todoRepository.getTodoList().then((value) {
      setState(() {
        tarefas = value;
      });
    });
  }

  void onDelete(Tarefa tarefa) {
    deletedTarefa = tarefa;
    deletedTarefaPos = tarefas.indexOf(tarefa);

    setState(() {
      tarefas.remove(tarefa);
    });
    todoRepository.saveTodoList(tarefas);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          height: 60.0,
          width: 350.0,
          alignment: Alignment.center,
          child: Text(
            'Tarefa ${tarefa.titulo} deletada com sucesso!',
            style: TextStyle(color: Color(0xFFB0B0B0)),
          ),
        ),
        duration: Duration(seconds: 5),
        backgroundColor: Color(0xFF181818),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Color(0xFFD4A200),
          onPressed: () {
            setState(() {
              tarefas.insert(deletedTarefaPos!, deletedTarefa!);
            });
            todoRepository.saveTodoList(tarefas);
          },
        ),
      ),
    );
  }

  void onEdit(Tarefa tarefa) {
    TextEditingController editController = TextEditingController(
      text: tarefa.titulo,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Editar Tarefa", style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF181818),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(
              labelText: "Nova descrição",
              border: OutlineInputBorder(),
              errorText: '',
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      Icon(Icons.cancel_outlined, color: Color(0xFFD4A200)),
                      SizedBox(width: 5),
                      Text("Cancelar",
                          style: TextStyle(color: Color(0xFFD4A200))),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          tarefa.titulo = editController.text;
                        });
                        todoRepository.saveTodoList(tarefas);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFD4A200)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.save, color: Colors.white),
                          SizedBox(width: 5),
                          Text("Salvar",
                            style: (TextStyle(color: Colors.white)),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        }

  void showDeleteTarefasConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF181818),
          title: Text("Limpar Tudo?", style: TextStyle(color: Colors.white)),
          content: Text(
            'Tem certeza que deseja deletar todas as tarefas?',
            style: TextStyle(color: Color(0xFFB0B0B0)),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.cancel_outlined, color: Color(0xFFD4A200)),
                      SizedBox(width: 5),
                      Text("Cancelar",
                        style: TextStyle(color: Color(0xFFD4A200)),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      tarefas.clear();
                    });
                    todoRepository.saveTodoList(tarefas);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFD32F2F),
                    foregroundColor: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.delete_forever, color: Colors.white),
                      SizedBox(width: 3),
                      Text("Limpar Tudo",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF181818),
        appBar: AppBar(
          title: Text(
            'App Tarefas',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFD4A200), Color(0xFFB58800)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 4,
          // leading: IconButton(
          // icon: Image.asset(
          // 'assets/images/app_tarefas.png',
          // width: 100,
          // height: 100,
          // fit: BoxFit.cover,
          // ),
          // onPressed: () {},
          // ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Lista de Tarefas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tarefaController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF222222),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFD4A200),
                            width: 2.0,
                          ),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Adicione uma Tarefa',
                        hintText: 'Ex. Estudar',
                        errorText: errorText,
                        floatingLabelStyle: TextStyle(color: Color(0xFFD4A200)),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD4A200),
                      fixedSize: Size(50, 50),
                      padding: const EdgeInsets.all(14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: () {
                      String text = tarefaController.text;

                      if (text.isEmpty) {
                        setState(() {
                          errorText = 'O campo não pode estar vazio';
                        });
                        return;
                      }

                      setState(() {
                        errorText = null;
                      });

                      setState(() {
                        Tarefa novaTarefa = Tarefa(
                          titulo: text,
                          dateTime: DateTime.now(),
                        );
                        tarefas.add(novaTarefa);
                        errorText = null;
                      });
                      tarefaController.clear();
                      todoRepository.saveTodoList(tarefas);
                    },
                    child: Icon(Icons.add, size: 25, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (Tarefa tarefa in tarefas)
                      TarefasItens(
                        tarefa: tarefa,
                        onDelete: onDelete,
                        onEdit: onEdit,
                      ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Você possui ${tarefas.length} tarefas pendentes',
                      style: TextStyle(color: Color(0xFFB0B0B0)),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD4A200),
                      fixedSize: Size(110, 50),
                      padding: const EdgeInsets.all(14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: showDeleteTarefasConfirmationDialog,
                    child: Text(
                      'Limpar tudo',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

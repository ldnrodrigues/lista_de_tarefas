import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/models/tarefas.dart';
import '../widgets/tarefas_item.dart';

class ListaTarefas extends StatefulWidget {
  ListaTarefas({super.key});

  @override
  State<ListaTarefas> createState() => _ListaTarefasState();
}

class _ListaTarefasState extends State<ListaTarefas> {
  final TextEditingController tarefaController = TextEditingController();
  List<Tarefa> tarefas = [];
  List<Tarefa> tarefasConcluidas = [];

  Tarefa? deletedTarefa;
  int? deletedTarefaPos;

  void onDelete(Tarefa tarefa) {
    deletedTarefa = tarefa;
    deletedTarefaPos = tarefas.indexOf(tarefa);

    setState(() {
      tarefas.remove(tarefa);
    });

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Color(0xFFD4A200),
          onPressed: () {
            setState(() {
              tarefas.insert(deletedTarefaPos!, deletedTarefa!);
            });
          },
        ),
      ),
    );
  }

  void onEdit(Tarefa tarefa) {
    TextEditingController editController = TextEditingController(text: tarefa.titulo);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Editar Tarefa",
          style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF181818),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(
              labelText: "Nova descrição",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tarefa.titulo = editController.text;
                });
                Navigator.pop(context);
              },
              child: Text("Salvar"),
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
          title: Text(
            "Limpar Tudo?",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Tem certeza que deseja deletar todas as tarefas?',
            style: TextStyle(color: Color(0xFFB0B0B0)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFFD32F2F),
                foregroundColor: Colors.white,
              ),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tarefas.clear();
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Text(
                "Limpar Tudo",
              style: TextStyle(color: Color(0xFFD4A200)),
              ),
            ),
          ],
        );
      },
    );
  }

  void tarefaConcluida(Tarefa tarefa) {
    setState(() {
      tarefas.remove(tarefa);
    })

    ;
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
          leading: IconButton(
            icon: Icon(Icons.task, color: Colors.white, size: 28), // Ícone representativo do app
            onPressed: () {},
          ),
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
                          borderSide: BorderSide(color: Color(0xFFD4A200), width: 2.0),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Adicione uma Tarefa',
                        hintText: 'Ex. Estudar',
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
                      setState(() {
                        Tarefa novaTarefa = Tarefa(
                          titulo: text,
                          dateTime: DateTime.now(),
                        );
                        tarefas.add(novaTarefa);
                      });
                      tarefaController.clear();
                    },
                    child: Icon(
                      Icons.add,
                      size: 25,
                      color: Colors.white,
                    ),
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
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

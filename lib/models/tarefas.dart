class Tarefa {

  Tarefa ({required this.titulo, required this.dateTime,});

  Tarefa.fromJson(Map<String, dynamic> json)
  : titulo = json['titulo'],
    dateTime = DateTime.parse(json['dateTime']);

  String titulo;
  DateTime dateTime;

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'dateTime': dateTime.toIso8601String(),
    };
  }

}
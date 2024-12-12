class RegistrosModel {
  final int id;
  final DateTime fecha;
  final String hora;
  final int cantidadMl;

  RegistrosModel({
    required this.id,
    required this.fecha,
    required this.hora,
    required this.cantidadMl,
  });

  // Código para convertir desde JSON
  factory RegistrosModel.fromJson(Map<String, dynamic> json) {
    return RegistrosModel(
      id: json['id'],
      fecha: DateTime.parse(json['fecha']),
      hora: json['hora'],
      cantidadMl: json['cantidad_ml'],
    );
  }
}

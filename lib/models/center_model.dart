// models/center_model.dart
class EducationalCenter {
  final String id;
  final String codigo;
  final String nombre;
  final String telefono;
  final String director;
  final String nivel;
  final String sector;
  final String distrito;

  EducationalCenter({
    required this.id,
    required this.codigo,
    required this.nombre,
    required this.telefono,
    required this.director,
    required this.nivel,
    required this.sector,
    required this.distrito,
  });

  factory EducationalCenter.fromJson(Map<String, dynamic> json) {
    return EducationalCenter(
      id: json['id'],
      codigo: json['codigo'],
      nombre: json['nombre'],
      telefono: json['telefono'],
      director: json['director'],
      nivel: json['nivel'],
      sector: json['sector'],
      distrito: json['distrito'],
    );
  }
}

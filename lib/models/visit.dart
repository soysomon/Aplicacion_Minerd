class Visit {
  final int id;
  final String directorId;
  final String centerCode;
  final String reason;
  final String photoPath;
  final String audioPath;
  final double latitude;
  final double longitude;
  final String date;
  final String time;
  final String comment;

  Visit({
    required this.id,
    required this.directorId,
    required this.centerCode,
    required this.reason,
    required this.photoPath,
    required this.audioPath,
    required this.latitude,
    required this.longitude,
    required this.date,
    required this.time,
    required this.comment,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0,
      directorId: json['cedula_director'] ?? '',
      centerCode: json['codigo_centro'] ?? '',
      reason: json['motivo'] ?? '',
      photoPath: json['foto_evidencia'] ?? '',
      audioPath: json['nota_voz'] ?? '',
      latitude: json['latitud'] != null ? double.parse(json['latitud'].toString()) : 0.0,
      longitude: json['longitud'] != null ? double.parse(json['longitud'].toString()) : 0.0,
      date: json['fecha'] ?? '',
      time: json['hora'] ?? '',
      comment: json['comentario'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cedula_director': directorId,
      'codigo_centro': centerCode,
      'motivo': reason,
      'foto_evidencia': photoPath,
      'nota_voz': audioPath,
      'latitud': latitude.toString(),
      'longitud': longitude.toString(),
      'fecha': date,
      'hora': time,
      'comentario': comment,
    };
  }
}

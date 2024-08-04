// lib/models/incident.dart

import '../database/incident_fields.dart';

class Incident {
  final int? id;
  final String title;
  final String center;
  final String regional;
  final String district;
  final String date;
  final String description;
  final String photoPath;
  final String audioPath;

  Incident({
    this.id,
    required this.title,
    required this.center,
    required this.regional,
    required this.district,
    required this.date,
    required this.description,
    required this.photoPath,
    required this.audioPath,
  });

  Incident copy({
    int? id,
    String? title,
    String? center,
    String? regional,
    String? district,
    String? date,
    String? description,
    String? photoPath,
    String? audioPath,
  }) =>
      Incident(
        id: id ?? this.id,
        title: title ?? this.title,
        center: center ?? this.center,
        regional: regional ?? this.regional,
        district: district ?? this.district,
        date: date ?? this.date,
        description: description ?? this.description,
        photoPath: photoPath ?? this.photoPath,
        audioPath: audioPath ?? this.audioPath,
      );

  Map<String, dynamic> toJson() => {
    IncidentFields.id: id,
    IncidentFields.title: title,
    IncidentFields.center: center,
    IncidentFields.regional: regional,
    IncidentFields.district: district,
    IncidentFields.date: date,
    IncidentFields.description: description,
    IncidentFields.photoPath: photoPath,
    IncidentFields.audioPath: audioPath,
  };

  static Incident fromJson(Map<String, dynamic> json) => Incident(
    id: json[IncidentFields.id] as int?,
    title: json[IncidentFields.title] as String,
    center: json[IncidentFields.center] as String,
    regional: json[IncidentFields.regional] as String,
    district: json[IncidentFields.district] as String,
    date: json[IncidentFields.date] as String,
    description: json[IncidentFields.description] as String,
    photoPath: json[IncidentFields.photoPath] as String,
    audioPath: json[IncidentFields.audioPath] as String,
  );
}

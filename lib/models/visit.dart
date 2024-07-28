import '../database/visit_database.dart';

class Visit {
  final int? id;
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
    this.id,
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

  Visit copy({
    int? id,
    String? directorId,
    String? centerCode,
    String? reason,
    String? photoPath,
    String? audioPath,
    double? latitude,
    double? longitude,
    String? date,
    String? time,
    String? comment,
  }) =>
      Visit(
        id: id ?? this.id,
        directorId: directorId ?? this.directorId,
        centerCode: centerCode ?? this.centerCode,
        reason: reason ?? this.reason,
        photoPath: photoPath ?? this.photoPath,
        audioPath: audioPath ?? this.audioPath,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        date: date ?? this.date,
        time: time ?? this.time,
        comment: comment ?? this.comment,
      );

  static Visit fromJson(Map<String, Object?> json) => Visit(
    id: json[VisitFields.id] as int?,
    directorId: json[VisitFields.directorId] as String,
    centerCode: json[VisitFields.centerCode] as String,
    reason: json[VisitFields.reason] as String,
    photoPath: json[VisitFields.photoPath] as String,
    audioPath: json[VisitFields.audioPath] as String,
    latitude: json[VisitFields.latitude] as double,
    longitude: json[VisitFields.longitude] as double,
    date: json[VisitFields.date] as String,
    time: json[VisitFields.time] as String,
    comment: json[VisitFields.comment] as String,
  );

  Map<String, Object?> toJson() => {
    VisitFields.id: id,
    VisitFields.directorId: directorId,
    VisitFields.centerCode: centerCode,
    VisitFields.reason: reason,
    VisitFields.photoPath: photoPath,
    VisitFields.audioPath: audioPath,
    VisitFields.latitude: latitude,
    VisitFields.longitude: longitude,
    VisitFields.date: date,
    VisitFields.time: time,
    VisitFields.comment: comment,
  };
}

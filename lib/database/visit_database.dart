// lib/models/visit.dart

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

  factory Visit.fromJson(Map<String, dynamic> json) => Visit(
    id: json['id'],
    directorId: json['directorId'],
    centerCode: json['centerCode'],
    reason: json['reason'],
    photoPath: json['photoPath'],
    audioPath: json['audioPath'],
    latitude: double.parse(json['latitude']),
    longitude: double.parse(json['longitude']),
    date: json['date'],
    time: json['time'],
    comment: json['comment'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'directorId': directorId,
    'centerCode': centerCode,
    'reason': reason,
    'photoPath': photoPath,
    'audioPath': audioPath,
    'latitude': latitude.toString(),
    'longitude': longitude.toString(),
    'date': date,
    'time': time,
    'comment': comment,
  };

  Visit copyWith({
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
  }) {
    return Visit(
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
  }
}

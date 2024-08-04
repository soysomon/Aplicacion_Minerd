// lib/database/incident_fields.dart

const String tableIncidents = 'incidents';

class IncidentFields {
  static final List<String> values = [
    id, title, center, regional, district, date, description, photoPath, audioPath
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String center = 'center';
  static const String regional = 'regional';
  static const String district = 'district';
  static const String date = 'date';
  static const String description = 'description';
  static const String photoPath = 'photoPath';
  static const String audioPath = 'audioPath';
}

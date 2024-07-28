class User {
  final int id;
  final String name;
  final String lastName;
  final String registrationNumber;
  final String photoUrl;

  User({
    required this.id,
    required this.name,
    required this.lastName,
    required this.registrationNumber,
    required this.photoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      lastName: json['lastName'],
      registrationNumber: json['registrationNumber'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'registrationNumber': registrationNumber,
      'photoUrl': photoUrl,
    };
  }
}

class PatientProfile {
  final String id;
  final String name;
  final String photoUrl;
  final DateTime dateOfBirth;
  final String bloodGroup;
  final String sex;
  final String phoneNumber;
  final String email;
  final String address;

  PatientProfile({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.dateOfBirth,
    required this.bloodGroup,
    required this.sex,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });

  // Convert PatientProfile to Map for storing in Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'bloodGroup': bloodGroup,
      'sex': sex,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
    };
  }

  // Create PatientProfile from Map (when fetching from Firebase)
  factory PatientProfile.fromMap(Map<String, dynamic> map) {
    return PatientProfile(
      id: map['id'],
      name: map['name'],
      photoUrl: map['photoUrl'],
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      bloodGroup: map['bloodGroup'],
      sex: map['sex'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      address: map['address'],
    );
  }
}

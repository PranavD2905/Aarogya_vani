class DoctorProfile {
  final String id;
  final String name;
  final String specialization;
  final String qualification;
  final String experience;
  final String photoUrl;
  final String bio;
  final String email;
  final String phoneNumber;
  final double rating;
  final int totalPatients;
  final int totalAppointments;

  DoctorProfile({
    required this.id,
    required this.name,
    required this.specialization,
    required this.qualification,
    required this.experience,
    required this.photoUrl,
    required this.bio,
    required this.email,
    required this.phoneNumber,
    this.rating = 0.0,
    this.totalPatients = 0,
    this.totalAppointments = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'qualification': qualification,
      'experience': experience,
      'photoUrl': photoUrl,
      'bio': bio,
      'email': email,
      'phoneNumber': phoneNumber,
      'rating': rating,
      'totalPatients': totalPatients,
      'totalAppointments': totalAppointments,
    };
  }

  factory DoctorProfile.fromMap(Map<String, dynamic> map) {
    return DoctorProfile(
      id: map['id'],
      name: map['name'],
      specialization: map['specialization'],
      qualification: map['qualification'],
      experience: map['experience'],
      photoUrl: map['photoUrl'],
      bio: map['bio'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      rating: map['rating']?.toDouble() ?? 0.0,
      totalPatients: map['totalPatients'] ?? 0,
      totalAppointments: map['totalAppointments'] ?? 0,
    );
  }
}

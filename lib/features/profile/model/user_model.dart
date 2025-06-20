class UserModel {
  final String? id;
  final String? fullName;
  final String? email;
  final String? username;
  final String? character;
  final List<dynamic>? ongoingMovements;
  final List<dynamic>? onClimbingMovements;
  final String? role;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final String? gender; 
  final String? phoneNumber; 

  UserModel({
    this.id,
    this.fullName,
    this.email,
    this.username,
    this.character,
    this.ongoingMovements,
    this.onClimbingMovements,
    this.role,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.gender, 
    this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      username: json['username'],
      character: json['character'],
      ongoingMovements: json['ongoingMovements'],
      onClimbingMovements: json['onClimbingMovements'],
      role: json['role'],
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      gender: json['gender'],
      phoneNumber: json['phoneNumber'],
    );
  }
}

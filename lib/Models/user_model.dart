class UserModel {
  final String? id;
  final String nom;
  final String email;
  final String role;
  final String poste;
  final String departement;
  final bool? isActive;
  final String? joinDate;
  final List<String>? permissions;

  UserModel({
    this.id,
    required this.nom,
    required this.email,
    required this.role,
    required this.poste,
    required this.departement,
    this.isActive,
    this.joinDate,
    this.permissions,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'],
      nom: json['nom'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'Employee',
      poste: json['poste'] ?? '',
      departement: json['departement'] ?? '',
      isActive: json['isActive'] ?? true,
      joinDate: json['createdAt'] ?? json['joinDate'],
      permissions: json['permissions']?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'email': email,
      'role': role,
      'poste': poste,
      'departement': departement,
      if (id != null) 'id': id,
      if (isActive != null) 'isActive': isActive,
    };
  }
}

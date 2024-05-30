class User {
  final String id;
  final String email;
  User({
    required this.id,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "id": id,
      };

  User copyWith({
    String? id,
    String? email,
    String? name,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
    );
  }
}

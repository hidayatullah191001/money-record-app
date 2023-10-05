// class User {
//   final int? id;
//   final String? name;
//   final String? email;
//   final String? roles;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final String? profilePhotoUrl;

//   User({
//     this.id,
//     this.name,
//     this.email,
//     this.roles,
//     this.createdAt,
//     this.updatedAt,
//     this.profilePhotoUrl,
//   });

//   factory User.fromJson(Map<String, dynamic> json) => User(
//         id: json["id"],
//         name: json["name"],
//         email: json["email"],
//         roles: json["roles"],
//         createdAt: json["created_at"] == null
//             ? null
//             : DateTime.parse(json["created_at"]),
//         updatedAt: json["updated_at"] == null
//             ? null
//             : DateTime.parse(json["updated_at"]),
//         profilePhotoUrl: json["profile_photo_url"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "email": email,
//         "roles": roles,
//         "created_at": createdAt?.toIso8601String(),
//         "updated_at": updatedAt?.toIso8601String(),
//         "profile_photo_url": profilePhotoUrl,
//       };
// }

class User {
  final String? idUser;
  final String? name;
  final String? email;
  final String? password;
  final String? createdAt;
  final String? updatedAt;

  User({
    this.idUser,
    this.name,
    this.email,
    this.password,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        idUser: json["id_user"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id_user": idUser,
        "name": name,
        "email": email,
        "password": password,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

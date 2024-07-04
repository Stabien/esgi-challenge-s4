class Profil {
  String firstname;
  String lastname;
  String email;
  String password;

  Profil({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
  });

  factory Profil.fromJson(Map<String, dynamic> json) {
    return Profil(
      firstname: json['Firstname'],
      lastname: json['Lastname'],
      email: json['Email'],
      password: json['Password'],
    );
  }
}

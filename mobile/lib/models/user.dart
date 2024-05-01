class UserCredentials {
  final String email;
  final String password;

  UserCredentials(
    this.email,
    this.password,
  );
}

class UserRegistrationPayload extends UserCredentials {
  final String firstname;
  final String lastname;

  UserRegistrationPayload(
    super.email,
    super.password,
    this.firstname,
    this.lastname,
  );
}

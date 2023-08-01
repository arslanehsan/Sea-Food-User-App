class CustomerObject {
  String? uid;

  String? name, password, email, phoneNumber;

  CustomerObject({
    this.uid,
    this.name,
    this.password,
    this.email,
    this.phoneNumber,
  });

  factory CustomerObject.fromJson(parsedJson) {
    return CustomerObject(
      uid: parsedJson['uid'],
      name: parsedJson['name'],
      phoneNumber: parsedJson['phoneNumber'],
      email: parsedJson['email'],
    );
  }
}

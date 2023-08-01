class CustomerObject {
  String? id, fName, lName, phone, address, email, pin;
  bool? verified;

  CustomerObject({
    this.id,
    this.fName,
    this.lName,
    this.phone,
    this.address,
    this.email,
    this.pin,
    this.verified,
  });
  factory CustomerObject.fromJson(parsedJson) {
    return CustomerObject(
      id: parsedJson['id'],
      fName: parsedJson['fName'],
      lName: parsedJson['lName'],
      phone: parsedJson['phone'],
      address: parsedJson['address'],
      email: parsedJson['email'],
      pin: parsedJson['pin'],
      verified: parsedJson['verified'],
    );
  }
}

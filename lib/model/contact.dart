class Contact {
  final String name;

  final String cellPhoneNumber;

  Contact(this.name, this.cellPhoneNumber);

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      map['name'] as String,
      map['cellPhoneNumber'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cellPhoneNumber': cellPhoneNumber,
    };
  }
}

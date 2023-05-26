class Contact {
  final String name;

  final String cellPhoneNumber;

  Contact(this.name, this.cellPhoneNumber);

  factory Contact.fromObject(Map map) {
    return Contact(map['name'], map['cellPhoneNumber']);
  }
}

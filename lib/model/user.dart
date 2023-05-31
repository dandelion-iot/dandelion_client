import 'package:dandelion_client/model/contact.dart';

class User {
  final String cellPhoneNumber;

  final String nickName;
  final List<Contact> contacts;

  User(this.cellPhoneNumber, this.nickName, this.contacts);

  factory User.fromObject(Map map) {
    List<dynamic>? contactList = map['contacts'];
    List<Contact> contacts = contactList?.map((item) => Contact.fromMap(item)).toList() ?? [];
    return User(map['cellPhoneNumber'], map['nickName'],contacts);
  }
}


import 'package:dandelion_client/service/rest_client.dart';
import 'package:flutter/material.dart';

class AddContactDialog extends StatefulWidget {
  final Function updateContactsTable ;
  const AddContactDialog({Key? key, required this.updateContactsTable}) : super(key: key);

  @override
  State<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  TextEditingController cellPhoneNumberController = TextEditingController();
  TextEditingController nameNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text("Add new contact"),
      content: Form(
        child: Column(
          children: [
            TextField(
              controller: cellPhoneNumberController,
              decoration: InputDecoration(labelText: "Phone Number"),
            ),
            TextField(
              controller: nameNumberController,
              decoration: InputDecoration(labelText: "Name"),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: addContact,
          child: Text("Add"),
        ),
      ],
    );
  }

  Future<void> addContact() async {
    String cellPhoneNumber = cellPhoneNumberController.text;
    String name = nameNumberController.text;
    if (cellPhoneNumber.isNotEmpty && name.isNotEmpty) {
      //TODO: implement me ...
      print('Add contact not implemented yet ...');
    }
  }
}

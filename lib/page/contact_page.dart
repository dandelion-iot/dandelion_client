import 'package:dandelion_client/constant.dart';
import 'package:dandelion_client/dialog/add_contact_dialog.dart';
import 'package:dandelion_client/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Contact> contactList = [];

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AddContactDialog(
                updateContactsTable: fetchContacts,
              ),
            );
          },
          child: Icon(Icons.person),
        ),
        appBar: AppBar(
          title: Text("Contacts"),
        ),
        body: ListView.builder(
          itemCount: contactList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                ),
                title: Text(contactList.elementAt(index).cellPhoneNumber),
                subtitle: Text(contactList.elementAt(index).name),
                trailing: IconButton(
                  onPressed: () => Navigator.of(context).pushNamed('/call', arguments: contactList.elementAt(index)),
                  icon: Icon(Icons.call),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> fetchContacts() async {
    setState(() {
      //TODO: implement me ...
      print('Fetch contacts not implemented yet ...');
    });
  }

  Future<void> eventListener() async {
    final sseClient = http.Client();
    final sseRequest = http.Request('GET', Uri.parse('http://example.com/events'));
    sseRequest.headers['Accept'] = 'text/event-stream';

    sseClient.send(sseRequest).then((sseResponse) {
      sseResponse.stream.listen((sseEvent) {
        print(sseEvent);
      });
    });
  }
}

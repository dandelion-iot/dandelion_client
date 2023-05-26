import 'package:dandelion_client/service/rest_client.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController cellPhoneNumberController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: cellPhoneNumberController,
                    decoration: InputDecoration(hintText: "Phone number"),
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: nickNameController,
                    decoration: InputDecoration(hintText: "Nick name"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: register,
                      child: Text("Register"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> register() async {
    var cellPhoneNumber = cellPhoneNumberController.text;
    var nickName = nickNameController.text;
    if (cellPhoneNumber.isNotEmpty && nickName.isNotEmpty) {
      var isRegistered = await RestClient.registerUser(cellPhoneNumber, nickName);
      if (isRegistered && context.mounted) {
        Navigator.of(context).pushNamed("/contacts");
      }
    }
  }
}

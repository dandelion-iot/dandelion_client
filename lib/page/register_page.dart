import 'package:dandelion_client/constant.dart';
import 'package:dandelion_client/service/rest_client.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController cellPhoneNumberController = TextEditingController();
  late bool sharedSecretState;

  @override
  void initState() {
    super.initState();
    var sharedSecret = prefs.getString('shared-secret');
    if (prefs.getString('shared-secret') == null || sharedSecret!.isEmpty) {
      print('Client is not logged in');
      RestClient.exchangeECDH().then((value) => value ? sharedSecretState = true : sharedSecretState = false);
    }
    // else {
    //   Future.delayed(Duration.zero, () {
    //     if(mounted) {
    //       Navigator.of(context).pushReplacementNamed('/contacts');
    //     }
    //   });
    // }
  }

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
    // print('register is called');
    // var cellPhoneNumber = cellPhoneNumberController.text;
    // RestClient.rpcCall(cellPhoneNumber, RPC.RPC_IDENTITY_AUTH);
  }
}

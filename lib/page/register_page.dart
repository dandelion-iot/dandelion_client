import 'package:dandelion_client/constant.dart';
import 'package:dandelion_client/service/rpc_producer.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController inputText = TextEditingController();
  late bool sharedSecretState;
  bool cellPhoneNumberScene = true;
  bool pageRefreshed = false;

  @override
  void initState() {
    super.initState();
    var sharedSecret = prefs.getString('shared-secret');
    var activationKey = prefs.getString('activation-key');
    if (sharedSecret == null || sharedSecret.isEmpty || activationKey == null || activationKey.isEmpty) {
      print('Client is not logged in');
      RPCProducer.sendPublicKey();
    } else {
      pageRefreshed = true;
      verifyActivationKey();
    }
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
                    controller: inputText,
                    decoration: InputDecoration(hintText: cellPhoneNumberScene ? "Phone number" : "Activation key"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: cellPhoneNumberScene ? register : verifyActivationKey,
                      child: Text(cellPhoneNumberScene ? "Request activation key" : "Verify"),
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
    print('Register called ...');
    await RPCProducer.sendAuthIdentity(inputText.text);
    setState(() {
      cellPhoneNumberScene = false;
      inputText.text = "";
    });
  }

  Future<void> verifyActivationKey() async {
    await RPCProducer.sendActivationKey(inputText.text);
  }
}

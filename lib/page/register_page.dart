import 'package:dandelion_client/constant.dart';
import 'package:dandelion_client/service/h5proto.dart';
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
    if (H5Proto.getActivationKey() == null || H5Proto.getSharedSecret() == null) {
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
    await RPCProducer.sendAuthIdentity(inputText.text);
    setState(() {
      cellPhoneNumberScene = false;
      inputText.text = "";
    });
  }

  Future<void> verifyActivationKey() async {
    var activationKey = inputText.text;
    if (pageRefreshed == true) activationKey = H5Proto.getActivationKey()!;
    await RPCProducer.sendActivationKey(activationKey);
    setState(() {
      pageRefreshed = false;
    });
  }
}

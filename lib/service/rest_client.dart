import 'dart:convert';

import 'package:dandelion_client/constant.dart';
import 'package:dandelion_client/model/contact.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class RestClient {
  static const storage = FlutterSecureStorage();
  static String baseURL = '/api/v1/resources';

  /*
  * Register new user
  * */
  static Future<bool> registerUser(
      String cellPhoneNumber, String nickName) async {
    print('Try to register user $cellPhoneNumber with nickname $nickName');
    String url = '$baseURL/register';
    print(url);
    var headers = {'Content-Type': 'application/json'};
    var queryParams = <String, String>{
      "cellPhoneNumber": cellPhoneNumber,
      "nickName": nickName
    };

    print(queryParams);

    var uri = Uri.http(serverBaseUrl, url, queryParams);
    print(uri);
    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      print('User registered success');
      await storage.write(key: "cellPhoneNumber", value: cellPhoneNumber);
      return true;
    }
    return false;
  }

  /*
  * Add a contact
  * */
  static Future<bool> addContact(String contactCellPhoneNumber, String name) async {
    String url = '$baseURL/contact';
    var cellPhoneNumber = await storage.read(key: 'cellPhoneNumber');
    var reqParameters = {
      'cellPhoneNumber': cellPhoneNumber,
      'contactCellPhoneNumber': contactCellPhoneNumber,
      'contactName': name,
    };
    var headers = {
      'Content-Type': 'application/json',
    };

    var uri = Uri.http(serverBaseUrl, url, reqParameters);
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  /*
  * Fetch list contacts
  * */
  static Future<List<Contact>> listContacts() async {
    String url = '$baseURL/contact/list';
    var cellPhoneNumber = await storage.read(key: 'cellPhoneNumber');
    var reqParameters = {'cellPhoneNumber': cellPhoneNumber};
    var headers = {
      'Content-Type': 'application/json',
    };

    var uri = Uri.http(serverBaseUrl, url, reqParameters);
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final listMap = jsonDecode(response.body) as List<dynamic>;
      return listMap.map((e) => Contact.fromObject(e)).toList();
    } else {
      print('Error: ${response.statusCode}');
    }
    return List.empty();
  }
}

import 'dart:convert';

import 'package:dandelion_client/constant.dart';
import 'package:dandelion_client/model/contact.dart';
import 'package:http/http.dart' as http;

class RestClient {
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

    return response.statusCode == 200 ? true : false;
  }

  /*
  * Add a contact
  * */
  static Future<bool> addContact(
      String contactCellPhoneNumber, String name) async {
    String url = '$baseURL/contact';
    var cellPhoneNumber = prefs.getString('cellPhoneNumber');
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
    var cellPhoneNumber = prefs.getString('cellPhoneNumber');
    var reqParameters = {'cellPhoneNumber': cellPhoneNumber};
    var headers = {
      'Content-Type': 'application/json',
    };

    var uri = Uri.http(serverBaseUrl, url, reqParameters);
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final listMap = jsonDecode(response.body) as List<dynamic>;
      return listMap.map((e) => Contact.fromMap(e)).toList();
    } else {
      print('Error: ${response.statusCode}');
    }
    return List.empty();
  }

  static Future<Future<http.StreamedResponse>> sseClient() async {
    var cellPhoneNumber = prefs.getString('cellPhoneNumber');
    String url = '$baseURL/sse/$cellPhoneNumber';

    final sseClient = http.Client();
    var uri = Uri.http(serverBaseUrl, url);
    final sseRequest = http.Request('GET', uri);
    sseRequest.headers['Accept'] = 'text/event-stream';

    return sseClient.send(sseRequest);
  }
}

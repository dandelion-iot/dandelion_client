import 'package:dandelion_client/model/contact.dart';
import 'package:dandelion_client/page/call_page.dart';
import 'package:dandelion_client/page/contact_page.dart';
import 'package:dandelion_client/page/register_page.dart';
import 'package:flutter/material.dart';

class RouteHandler {
  static Route<dynamic> handle(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case "/contacts":
        return MaterialPageRoute(builder: (_) => ContactPage());
      case "/call":
        var arguments = settings.arguments as Map<String, dynamic>;
        var contact = arguments['targetContact'] as Contact?;
        var room = arguments['room'] as String?;
        return MaterialPageRoute(
          builder: (_) => CallPage(
            targetContact: contact,
            room: room,
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => RegisterPage());
    }
  }
}

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
        var contact = settings.arguments as Contact?;
        return MaterialPageRoute(
          builder: (_) => CallPage(targetContact: contact),
        );
      default:
        return MaterialPageRoute(builder: (_) => RegisterPage());
    }
  }
}

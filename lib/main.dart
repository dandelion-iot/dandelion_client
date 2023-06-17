import 'package:dandelion_client/service/route_generator.dart';
import 'package:dandelion_client/service/websocket_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(Application());
}

class Application extends StatelessWidget {
  late final WebSocketService _ws = WebSocketService();

  Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _ws.navigatorKey,
      theme: ThemeData.light(),
      title: 'Dandelion',
      initialRoute: '/',
      onGenerateRoute: RouteHandler.handle,
    );
  }
}

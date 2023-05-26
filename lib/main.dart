import 'package:dandelion_client/service/route_generator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Application());
}

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      title: 'Dandelion',
      initialRoute: '/register',
      onGenerateRoute: RouteHandler.handle,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_1/service_locator.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/config/flavor_config.dart';

void main() async {
  // Initialize prod flavor
  await FlavorConfig.initialize(FlavorConfig.prod);
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = FlavorConfig.instance;
    
    return MaterialApp(
      title: config.name,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginScreen(),
    );
  }
}

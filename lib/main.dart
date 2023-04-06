import 'package:flutter/material.dart';
import '../database/database.dart';
import '../models/model_user.dart';
import 'widgets/widgets.dart';
import 'widgets/login_screen.dart';

void main() async {
  // Создаем базу данных
  final appDatabase = AppDatabase();
  await appDatabase.createTableIfNotExists();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration Page',
      home: LoginScreen(),
      routes: {
        '/main': (context) => MainScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}

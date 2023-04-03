// // import 'package:postgres/postgres.dart';
// import '../database/database.dart';
// import 'package:flutter/material.dart';
// import '../models/model_user.dart';
//
//
//
// void main() async {
//   // Создайте экземпляр класса AppDatabase
//   var appDatabase = AppDatabase();
//
//   // Вызовите метод для подключения к базе данных
//   await appDatabase.connection;
// }



import 'package:flutter/material.dart';
import '../database/database.dart';
import '../models/model_user.dart';

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
    return const MaterialApp(
      title: 'Registration Page',
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Create an instance of the UserModel model to store the user's entered data
  UserModel user = UserModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Page'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    user.name = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    user.email = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    user.password = value!;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Save the user's data to the database
                      AppDatabase().addUserToDatabase(user);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Registration Successful!'),
                        ),
                      );
                    }
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ), // closing padding
        ), // closing form
      ), // closing SingleChildScrollView
    ); // closing Scaffold
  }
}
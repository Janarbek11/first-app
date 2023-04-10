import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:postgres/postgres.dart';
import '../models/model_user.dart';

// подключение к БД
final appDatabase = AppDatabase();

// переменные определения для хеширования исоли паролей
final bytes = utf8.encode('password');
final hash = sha256.convert(bytes);
final hashString = hash.toString();

class AppDatabase {
  PostgreSQLConnection? connection;

   AppDatabase() {
    connection = PostgreSQLConnection(
      '192.168.56.1', // IP-адрес или доменное имя сервера базы данных
      5432, // порт сервера базы данных
      'trackerapp', // имя базы данных
      username: 'adiletsot', // имя пользователя базы данных
      password: 'jake', // пароль пользователя базы данных
    );
  }

  Future<void> createTableIfNotExists() async {
    try {
      await connection!.open();
      await connection!.query('''
        CREATE TABLE IF NOT EXISTS users (
          id SERIAL PRIMARY KEY,
          name VARCHAR(50) NOT NULL,
          email VARCHAR(50) NOT NULL,
          password TEXT NOT NULL
        );
      ''');
    } catch (e) {
      print('Error creating table: $e');
    } finally {
      await connection!.close();
    }
  }

  Future<void> addUserToDatabase(UserModel userModel) async {
    try {
      await connection!.open();
      final salt = generateSalt();
      final hashedPassword = hashPassword(userModel.password.join(''), salt);
      await connection!.query(
        "INSERT INTO users (name, email, password) VALUES (@name, @email, @password)",
        substitutionValues: {
          'name': userModel.name,
          'email': userModel.email,
          'password': '$hashedPassword:$salt',
        },
      );
      print('User added to database');
    } catch (e) {
      print('Error adding user to database: $e');
    } finally {
      await connection!.close();
    }
  }



  Future<UserModel?> getUserByEmailAndPassword(String email, String password) async {
    try {
      await appDatabase.connection!.open();
      final result = await appDatabase.connection!.query(
        'SELECT * FROM users WHERE email = @email LIMIT 1',
        substitutionValues: {'email': email},
      );
      if (result.isNotEmpty) {
        final userData = result.first.asMap();
        final salt = (userData['password'] != null) ? userData['password'].split(':').last : '';
        final hashedPassword = hashPassword(password, salt);
        if (userData['password'] != null && userData['password'].split(':').first == hashedPassword) {
          return UserModel.fromMap(userData.cast<String, dynamic>());
        }
      }
    } finally {
      await appDatabase.connection?.close();
    }
    return null;
  }

  String generateSalt() {
    final random = Random.secure();
    final List<int> bytes = List.generate(16, (_) => random.nextInt(256));
    return base64Url.encode(bytes);
  }

  String hashPassword(String password, String salt) {
    final saltedPassword = utf8.encode(password + salt);
    final digest = sha256.convert(saltedPassword);
    return digest.toString();
  }
}
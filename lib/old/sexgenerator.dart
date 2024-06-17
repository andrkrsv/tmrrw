import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

const chars =
    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_-+={}[]|;:,.<>?';

String generateSecret(int length) {
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}

const _storage = FlutterSecureStorage();

Future<void> sendAndSaveSecret() async {
  final secret = generateSecret(32); // Генерируем секрет

  try {
    final response = await http.post(
      Uri.parse('http://172.211.128.119:8090/getkey'),
      body: jsonEncode({'SECRET': secret}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      await _storage.write(key: 'secret', value: secret); // Сохраняем секрет
      print('Secret sent and saved successfully');
    } else {
      throw Exception('Failed to send secret');
    }
  } catch (error) {
    print('Error sending or saving secret: $error');
    // Дополнительная обработка ошибок, например, уведомление пользователя
  }
}

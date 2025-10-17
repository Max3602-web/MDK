import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  final String val;
  const SignInScreen({super.key, required this.val});

  @override
  Widget build(BuildContext context) {
    //final counterValue = ModalRoute.of(context)!.settings.arguments as int?;
    //final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    //print(ModalRoute.of(context)?.settings.arguments);
    //print(arguments);
    print(val);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Вернуться на предыдущий экран
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Первая строка ввода
            TextField(
              decoration: InputDecoration(
                labelText: 'Введите имя',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            // Вторая строка ввода
            TextField(
              decoration: InputDecoration(
                labelText: 'Введите email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // Красный квадрат
            Container(
              color: Colors.red,
              width: 100,
              height: 100,
              child: const Center(
                child: Text(
                  'Экран регистрации',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Вывод значения counterValue
            Text(
              val != null
                  ? 'Передано значение счётчика: $val'
                  : 'Значение счётчика не передано',
              style: const TextStyle(fontSize: 18),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
}
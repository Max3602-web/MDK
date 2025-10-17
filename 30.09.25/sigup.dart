import 'package:flutter/material.dart';
import 'package:flutter_app/tetris.dart';
// ignore: unused_import
import 'Chess.dart'; // импортируем файл с вашим экраном, а также предполагаемый SignInScreen

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Введите имя',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Введите email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              color: Colors.green,
              width: 100,
              height: 100,
              child: const Center(
                child: Text(
                  'Экран регистрации',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChessApp(),
                  ),
                );
              },
              child: const Text('Перейти на Chess Screen'),
            ),
            const SizedBox(height: 20),
            // Новая кнопка для перехода на другую страницу
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Tetris(val: 'Привет!'), // Передача параметра, если нужно
                  ),
                );
              },
              child: const Text('Перейти на SignIn Screen'),
            ),
          ],
        ),
      ),
    );
  }
}

// Предположим, что ваш SignInScreen выглядит так:


@override
Widget build(BuildContext context) {
    String val;
    return Scaffold(
     appBar: AppBar(title: Text('Sign In')),
     body: Center(
     child: Text(val),
    ),
  );
}
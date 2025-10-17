import 'package:flutter/material.dart'; // Импорт основного пакета Flutter для построения UI
import 'package:flutter_app/sigin.dart'; // Импорт экрана SignIn
import 'package:flutter_app/sigup.dart'; // Импорт экрана SignUp
import 'dart:math'; // Импорт библиотеки для генерации случайных чисел

void main() {
  runApp(const MyApp()); // Запуск главного виджета приложения
}

// Основной виджет приложения, не меняется
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Конструктор, вызывающий родительский

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App!!', // Заголовок приложения
      routes: {
        // Отдельный маршрут на страницу SignUp
        "/ptu": (context) => SignUpScreen(),
      },
      home: const MyHomePage(title: 'Flutter Example App'), // Основная страница
      debugShowCheckedModeBanner: false, // Отключение панели Debug
    );
  }
}

// Главная страница с состоянием (например, счетчик и сообщения)
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title}); // Получение заголовка страницы

  final String title; // Заголовок страницы

  @override
  State<MyHomePage> createState() => _MyHomePageState(); // Создаем состояние
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0; // Переменная счетчика

  // Список сообщений, которые будут показываться случайным образом
  final List<String> _messages = [
    'Действие выполнено!',
    'Обработка завершена!',
    'Отлично, попробуйте еще раз!',
    'Сообщение успешно!',
    'Победа!',
  ];

  final Random _random = Random(); // Объект для генерации случайных чисел
  String _currentMessage = ''; // Текущее отображаемое сообщение
  bool _showMessage = false; // Флаг отображения сообщения

  // Метод для выбора и отображения случайного сообщения
  void _showRandomMessage() {
    setState(() {
      _currentMessage = _messages[_random.nextInt(_messages.length)];
      _showMessage = true; // Включение отображения сообщения
    });
    // Через 2 секунды скрываем сообщение
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showMessage = false; // Отключение отображения сообщения
      });
    });
  }

  // Метод, увеличивающий счетчик и показывающий сообщение
  void _incrementCounter() {
    setState(() {
      _counter++; // Увеличить счетчик на 1
    });
    _showRandomMessage(); // Показать случайное сообщение при каждом нажатии
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // Заголовок приложения
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Центрирование по вертикали
          children: [
            // Кнопка для перехода на экран SignIn
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => SignInScreen(val: '$_counter'), // Передача счетчика как параметра
                  ),
                );
                _showRandomMessage(); // Также показываем сообщение
              },
              child: const Text('Перейти на SignIn'), // Текст кнопки
            ),
            const SizedBox(height: 10), // Вертикальный отступ
            // Кнопка для перехода на экран SignUp
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/ptu', // Название маршрута
                  arguments: _counter, // Передача счетчика через arguments
                );
                _showRandomMessage(); // Также показываем сообщение
              },
              child: const Text('Перейти на SignUp'), // Текст кнопки
            ),
            const SizedBox(height: 20), // Большой отступ
            // Текст, показывающий сколько раз нажимали на кнопку
            const Text('You have pushed the button this many times:'),
            // Отображение счетчика
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20), // Отступ перед сообщением
            // Условное отображение окна сообщения
            if (_showMessage)
              Container(
                padding: const EdgeInsets.all(10), // Внутренний отступ
                color: Colors.green[100], // Цвет фона
                child: Text(
                  _currentMessage, // Текст сообщения
                  style: const TextStyle(color: Colors.green), // Цвет текста
                ),
              ),
          ],
        ),
      ),
      // Плавающая кнопка для увеличения счетчика
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter, // Обработчик нажатия
        tooltip: 'Increment', // Подсказка
        child: const Icon(Icons.add), // Иконка "+"
      ),
    );
  }
}
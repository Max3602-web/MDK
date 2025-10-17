import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
class Tetris extends StatelessWidget {
  final String val;
  const Tetris({super.key, required this.val});

  @override
  Widget build(BuildContext context) {
    //final counterValue = ModalRoute.of(context)!.settings.arguments as int?;
    //final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    //print(ModalRoute.of(context)?.settings.arguments);
    //print(arguments);
    print(val);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Тетрис на Flutter'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Вернуться на предыдущий экран
          },
        ),
      ),);
      }
      }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Тетрис на Flutter',
      debugShowCheckedModeBanner: false,
      home: GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const int rowCount = 20;
  static const int colCount = 10;

  late Timer timer;
  List<List<int>> board = List.generate(
    rowCount,
    (_) => List.generate(colCount, (_) => 0),
  );

  late Shape currentShape;
  int currentRow = 0;
  int currentCol = 4;

  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    spawnShape();
    timer = Timer.periodic(Duration(milliseconds: 500), (_) {
      if (!gameOver) {
        setState(() {
          if (!moveDown()) {
            fixShape();
            clearLines();
            spawnShape();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void spawnShape() {
    final random = Random();
    currentShape = Shape.random(random);
    currentRow = 0;
    currentCol = (colCount ~/ 2) - (currentShape.shape[0].length ~/ 2);
    if (isCollision(currentShape, currentRow, currentCol)) {
      gameOver = true;
      timer.cancel();
      showGameOverDialog();
    }
  }

  bool isCollision(Shape shape, int row, int col) {
    for (int r = 0; r < shape.shape.length; r++) {
      for (int c = 0; c < shape.shape[r].length; c++) {
        if (shape.shape[r][c] != 0) {
          int newRow = row + r;
          int newCol = col + c;
          if (newCol < 0 || newCol >= colCount || newRow >= rowCount) {
            return true;
          }
          if (newRow >= 0 && board[newRow][newCol] != 0) {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool moveDown() {
    if (!isCollision(currentShape, currentRow + 1, currentCol)) {
      currentRow++;
      return true;
    }
    return false;
  }

  void fixShape() {
    for (int r = 0; r < currentShape.shape.length; r++) {
      for (int c = 0; c < currentShape.shape[r].length; c++) {
        if (currentShape.shape[r][c] != 0) {
          int rowIdx = currentRow + r;
          int colIdx = currentCol + c;
          if (rowIdx >= 0 && rowIdx < rowCount && colIdx >= 0 && colIdx < colCount) {
            board[rowIdx][colIdx] = currentShape.color;
          }
        }
      }
    }
  }

  void clearLines() {
    List<List<int>> newBoard = [];
    for (var row in board) {
      if (row.any((cell) => cell == 0)) {
        newBoard.add(row);
      }
    }
    int cleared = rowCount - newBoard.length;
    for (int i = 0; i < cleared; i++) {
      newBoard.insert(0, List.filled(colCount, 0));
    }
    board = newBoard;
  }

  void moveLeft() {
    if (!isCollision(currentShape, currentRow, currentCol - 1)) {
      setState(() {
        currentCol--;
      });
    }
  }

  void moveRight() {
    if (!isCollision(currentShape, currentRow, currentCol + 1)) {
      setState(() {
        currentCol++;
      });
    }
  }

  void rotate() {
    final newShape = currentShape.rotate();
    if (!isCollision(newShape, currentRow, currentCol)) {
      setState(() {
        currentShape = newShape;
      });
    }
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Игра окончена'),
        content: Text('Вы проиграли. Хотите начать заново?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                board = List.generate(
                  rowCount,
                  (_) => List.generate(colCount, (_) => 0),
                );
                gameOver = false;
                spawnShape();
                timer = Timer.periodic(Duration(milliseconds: 500), (_) {
                  if (!gameOver) {
                    setState(() {
                      if (!moveDown()) {
                        fixShape();
                        clearLines();
                        spawnShape();
                      }
                    });
                  }
                });
              });
            },
            child: Text('Начать заново'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Создаем копию доски для отрисовки, добавляем текущую фигуру
    List<List<int>> displayBoard = List.generate(
        rowCount, (r) => List.generate(colCount, (c) => board[r][c]));

    for (int r = 0; r < currentShape.shape.length; r++) {
      for (int c = 0; c < currentShape.shape[r].length; c++) {
        if (currentShape.shape[r][c] != 0) {
          int rowIdx = currentRow + r;
          int colIdx = currentCol + c;
          if (rowIdx >= 0 &&
              rowIdx < rowCount &&
              colIdx >= 0 &&
              colIdx < colCount) {
            displayBoard[rowIdx][colIdx] = currentShape.color;
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Тетрис на Flutter'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.all(4),
              child: GridView.builder(
                itemCount: rowCount * colCount,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: colCount),
                itemBuilder: (context, index) {
                  int row = index ~/ colCount;
                  int col = index % colCount;
                  int colorIndex = displayBoard[row][col];
                  Color color;
                  if (colorIndex == 0) {
                    color = Colors.grey[900]!;
                  } else {
                    color = Colors.primaries[
                        (colorIndex - 1) % Colors.primaries.length];
                  }
                  return Container(
                    margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: gameOver ? null : moveLeft,
                  child: Icon(Icons.arrow_left)),
              ElevatedButton(
                  onPressed: gameOver ? null : rotate,
                  child: Icon(Icons.rotate_right)),
              ElevatedButton(
                  onPressed: gameOver ? null : moveRight,
                  child: Icon(Icons.arrow_right)),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class Shape {
  final List<List<int>> shape;
  final int color;

  Shape(this.shape, this.color);

  Shape rotate() {
    int rows = shape.length;
    int cols = shape[0].length;
    List<List<int>> newShape = List.generate(
        cols, (_) => List.generate(rows, (_) => 0));
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        newShape[c][rows - 1 - r] = shape[r][c];
      }
    }
    return Shape(newShape, color);
  }

  static final List<List<List<int>>> shapes = [
    // I
    [
      [1, 1, 1, 1],
    ],
    // O
    [
      [2, 2],
      [2, 2],
    ],
    // T
    [
      [0, 3, 0],
      [3, 3, 3],
    ],
    // S
    [
      [0, 4, 4],
      [4, 4, 0],
    ],
    // Z
    [
      [5, 5, 0],
      [0, 5, 5],
    ],
    // J
    [
      [6, 0, 0],
      [6, 6, 6],
    ],
    // L
    [
      [0, 0, 7],
      [7, 7, 7],
    ],
  ];

  static Shape random(Random rand) {
    final index = rand.nextInt(shapes.length);
    final shapeData = shapes[index];
    // Цвет берем просто как index + 1, чтобы совпадал с цветами в списке
    final colorIndex = index + 1;
    return Shape(shapeData, colorIndex);
  }
}
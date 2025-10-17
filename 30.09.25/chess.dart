import 'package:flutter/material.dart';

void main() {
  runApp(const ChessApp());
}

class ChessApp extends StatelessWidget {
  const ChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChessBoard(),
    );
  }
}

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  // 8x8 поле, где каждый элемент — код фигуры (или пусто "")
  // Используем простые обозначения: wp - белая пешка, bk - черный король и т.п.
  // Тут простая стартовая позиция
  List<List<String>> board = [
    ['br', 'bn', 'bb', 'bq', 'bk', 'bb', 'bn', 'br'],
    ['bp', 'bp', 'bp', 'bp', 'bp', 'bp', 'bp', 'bp'],
    ['', '', '', '', '', '', '', ''],
    ['', '', '', '', '', '', '', ''],
    ['', '', '', '', '', '', '', ''],
    ['', '', '', '', '', '', '', ''],
    ['wp', 'wp', 'wp', 'wp', 'wp', 'wp', 'wp', 'wp'],
    ['wr', 'wn', 'wb', 'wq', 'wk', 'wb', 'wn', 'wr'],
  ];

  int? selectedRow;
  int? selectedCol;

  // Карты текстовых значков фигур (упрощенно, можно заменить на изображения)
  static const Map<String, String> pieceSymbols = {
    'wp': '♙',
    'wr': '♖',
    'wn': '♘',
    'wb': '♗',
    'wq': '♕',
    'wk': '♔',
    'bp': '♟︎',
    'br': '♜',
    'bn': '♞',
    'bb': '♝',
    'bq': '♛',
    'bk': '♚',
  };

  void onCellTap(int row, int col) {
    setState(() {
      if (selectedRow == null) {
        // Если ничего не выбрано, выбираем фигуру если там есть
        if (board[row][col] != '') {
          selectedRow = row;
          selectedCol = col;
        }
      } else {
        // Если фигура выбрана — пытаемся переместить в новую клетку
        // Без проверки правил, просто перемещение пустая или дружественная фигура
        // Можно усложнить тут логику проверки ходов
        board[row][col] = board[selectedRow!][selectedCol!];
        board[selectedRow!][selectedCol!] = '';
        selectedRow = null;
        selectedCol = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width / 8;

    return Scaffold(
      appBar: AppBar(title: const Text('Упрощённые шахматы')),
      body: Column(
        children: List.generate(8, (row) {
          return Row(
            children: List.generate(8, (col) {
              bool isSelected = selectedRow == row && selectedCol == col;
              bool isDark = (row + col) % 2 == 1;

              return GestureDetector(
                onTap: () => onCellTap(row, col),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.orange
                        : isDark
                            ? Colors.brown[400]
                            : Colors.brown[200],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    pieceSymbols[board[row][col]] ?? '',
                    style: TextStyle(
                      fontSize: size * 0.7,
                      color: board[row][col].startsWith('w')
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
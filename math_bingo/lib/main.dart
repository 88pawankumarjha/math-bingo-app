// lib/main.dart
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MathBingoApp());

class MathBingoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Bingo',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Math Bingo')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Start Game'),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BingoScreen())),
        ),
      ),
    );
  }
}

class BingoScreen extends StatefulWidget {
  @override
  _BingoScreenState createState() => _BingoScreenState();
}

class _BingoScreenState extends State<BingoScreen> {
  final int rows = 3;
  final int cols = 5;
  late List<Tile> board;

  @override
  void initState() {
    super.initState();
    board = generateBoard(rows * cols);
  }

  List<Tile> generateBoard(int n) {
    final rand = Random();
    // create simple math tasks like "2+3", "4-1", "3x2"
    final ops = ['+', '-', '×'];
    Set<int> used = {};
    List<Tile> list = [];
    while (list.length < n) {
      int a = rand.nextInt(9) + 1;
      int b = rand.nextInt(9) + 1;
      String op = ops[rand.nextInt(ops.length)];
      int value;
      String expr;
      if (op == '+') { value = a + b; expr = '$a+$b'; }
      else if (op == '-') { value = (a>=b) ? a-b : b-a; expr = (a>=b) ? '$a-$b' : '$b-$a'; }
      else { value = a * b; expr = '$a×$b'; }
      if (used.contains(value)) continue; // avoid duplicate results
      used.add(value);
      list.add(Tile(expr: expr, value: value));
    }
    return list;
  }

  void toggleMark(int idx) {
    setState(() => board[idx].marked = !board[idx].marked);
    if (checkWin()) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Bingo!'),
          content: Text('You made a line!'),
          actions: [TextButton(onPressed: (){ Navigator.pop(context); }, child: Text('OK'))],
        ),
      );
    }
  }

  bool checkWin() {
    // simple: check any full row
    for (int r=0; r<rows; r++) {
      bool full = true;
      for (int c=0; c<cols; c++) {
        if (!board[r*cols + c].marked) { full = false; break; }
      }
      if (full) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bingo Board')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: board.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cols, childAspectRatio: 1.2, crossAxisSpacing: 8, mainAxisSpacing: 8),
          itemBuilder: (context, idx) {
            final t = board[idx];
            return GestureDetector(
              onTap: () => toggleMark(idx),
              child: Container(
                decoration: BoxDecoration(
                  color: t.marked ? Colors.lightGreenAccent : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Center(child: Text(t.expr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () => setState(() => board = generateBoard(rows*cols)),
      ),
    );
  }
}

class Tile {
  final String expr;
  final int value;
  bool marked;
  Tile({required this.expr, required this.value, this.marked = false});
}

import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  final int gridSize;
  final List<Map<String, int>> moves;
  final Function(int p1, int p2) onLineDrawn;

  const GameBoard({
    super.key,
    required this.gridSize,
    required this.moves,
    required this.onLineDrawn,
  });

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  Offset? _startPos;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onPanStart: (details) {
              _startPos = details.localPosition;
            },
            onPanEnd: (details) {
              if (_startPos != null) {
                _handleSwipe(_startPos!, details.localPosition, constraints.maxWidth);
                _startPos = null;
              }
            },
            child: CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: BoardPainter(widget.gridSize, widget.moves),
            ),
          );
        },
      ),
    );
  }

  void _handleSwipe(Offset start, Offset end, double size) {
    double spacing = size / (widget.gridSize - 1);

    int? p1 = _getNearestDot(start, spacing);
    int? p2 = _getNearestDot(end, spacing);

    if (p1 != null && p2 != null && p1 != p2) {
      // Check adjacency
      if (_isAdjacent(p1, p2)) {
        widget.onLineDrawn(p1, p2);
      }
    }
  }

  int? _getNearestDot(Offset pos, double spacing) {
    int col = (pos.dx / spacing).round();
    int row = (pos.dy / spacing).round();

    if (col < 0 || col >= widget.gridSize || row < 0 || row >= widget.gridSize) {
      return null;
    }

    // Optional: Check if touch is close enough to dot radius
    // For better UX, we allow snapping if reasonably close

    return row * widget.gridSize + col;
  }

  bool _isAdjacent(int p1, int p2) {
    int row1 = p1 ~/ widget.gridSize;
    int col1 = p1 % widget.gridSize;
    int row2 = p2 ~/ widget.gridSize;
    int col2 = p2 % widget.gridSize;

    int dRow = (row1 - row2).abs();
    int dCol = (col1 - col2).abs();

    return (dRow + dCol) == 1;
  }
}

class BoardPainter extends CustomPainter {
  final int gridSize;
  final List<Map<String, int>> moves;

  BoardPainter(this.gridSize, this.moves);

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    double spacing = size.width / (gridSize - 1);

    // Draw moves first
    for (var move in moves) {
      if (move['p1'] != null && move['p2'] != null) {
        int p1 = move['p1']!;
        int p2 = move['p2']!;

        Offset o1 = _getOffset(p1, spacing);
        Offset o2 = _getOffset(p2, spacing);
        canvas.drawLine(o1, o2, linePaint);
      }
    }

    // Draw dots
    for (int j = 0; j < gridSize; j++) {
      for (int i = 0; i < gridSize; i++) {
        canvas.drawCircle(Offset(i * spacing, j * spacing), 6.0, dotPaint);
      }
    }
  }

  Offset _getOffset(int p, double spacing) {
    int x = p % gridSize;
    int y = p ~/ gridSize;
    return Offset(x * spacing, y * spacing);
  }

  @override
  bool shouldRepaint(covariant BoardPainter oldDelegate) {
    return oldDelegate.moves != moves;
  }
}

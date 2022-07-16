import 'package:flutter/material.dart';

class LineIndicator extends Decoration {
  final Color color;
  final double radius;

  LineIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _LinePainter(color: color, radius: radius);
  }
}

class _LinePainter extends BoxPainter {
  final Color color;
  final double radius;

  _LinePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    late Paint _paint;
    _paint = Paint()
      ..color = color
      ..isAntiAlias = true
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final Offset lineOffset =
        offset + Offset(cfg.size!.width / 3, cfg.size!.height);
    final Offset lineOffset2 =
        offset + Offset(cfg.size!.width / 3 * 2, cfg.size!.height);
    canvas.drawLine(lineOffset, lineOffset2, _paint);
  }
}

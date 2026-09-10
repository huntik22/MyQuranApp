import 'package:flutter/material.dart';
import 'dart:math' as math;

class SurahNumberBadge extends StatelessWidget {
  final int number;
  final double size;
  final Color color;

  const SurahNumberBadge({
    super.key,
    required this.number,
    this.size = 44,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OctagonPainter(color: color),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Text(
            '$number',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class _OctagonPainter extends CustomPainter {
  final Color color;
  _OctagonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    const sides = 8;
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < sides; i++) {
      final angle = (math.pi / sides) + (i * 2 * math.pi / sides);
      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      i == 0 ? path.moveTo(point.dx, point.dy) : path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _OctagonPainter oldDelegate) => false;
}
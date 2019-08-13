import 'package:bank_management/utils/Style.dart';
import 'package:flutter/material.dart';

class Custompaint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CustomPaint(
      child: Container(
        height: size.height / 2,
        width: size.width,
      ),
      painter: CurvePainter(),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
        size.width * 0.8, size.height * 1.1, size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    path.close();

    paint.color = Colors.lightBlueAccent;
    canvas.drawPath(path, paint);

    path = Path();
    path.lineTo(0, size.height * 0.90);
    path.quadraticBezierTo(size.width * 0.7, size.height * 1.20,
        size.width * 0.7, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.45,
        size.width * 0.85, size.height * 0.40);
    path.quadraticBezierTo(
        size.width * 0.95, size.height * 0.38, size.width, size.height * 0.30);
    path.lineTo(size.width, 0);
    path.close();

    paint.color = darkColor;
    canvas.drawPath(path, paint);

    path = Path();

    path.lineTo(0, size.height / 1.5);
    path.quadraticBezierTo(size.width * 0.08, size.height / 1.5,
        size.width * 0.10, size.height / 2);
    path.quadraticBezierTo(size.width * 0.15, size.height * 0.05,
        size.width * 0.60, size.height * 0.10);
    path.quadraticBezierTo(size.width * 0.70, size.height * 0.10,
        size.width * 0.80, -size.height * 0.001);
    path.close();

    paint.color = orange;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

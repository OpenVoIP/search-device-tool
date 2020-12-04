import 'package:flutter/material.dart';
import 'package:search_tool/i10n/localizations.dart';
import 'package:search_tool/main.dart';

class DividerAdmin extends CustomPainter {
  Paint defaultPaint;
  Color color;

  // 设置画笔颜色
  DividerAdmin(this.color) {
    //根据颜色返回不同的画笔
    defaultPaint = Paint() //生成画笔
      ..strokeWidth = 2
      ..color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(0, 10), Offset(150, 10), defaultPaint);
    canvas.drawLine(Offset(230, 10), Offset(400, 10), defaultPaint);

    TextSpan span = new TextSpan(
      style: new TextStyle(color: Colors.blue[800]),
      text: AppLocalizations.of(navigatorKey.currentState.overlay.context)
          .password,
    );
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, new Offset(160.0, 0));
  }

  // 判断是否需要重绘，这里我们简单的做下比较即可
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}

//Loading包装成一个新的控件
class DividerAdminLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: CustomPaint(
      size: Size(400, 20),
      painter: DividerAdmin(Colors.blue),
    ));
  }
}

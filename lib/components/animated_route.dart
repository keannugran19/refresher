import 'package:flutter/material.dart';

class AnimatedRoute extends PageRouteBuilder {
  final Widget widget;
  final Offset offset;
  AnimatedRoute({required this.widget, required this.offset})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) {
          return widget;
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final begin = offset;
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
}

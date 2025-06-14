import 'package:flutter/material.dart';

class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final AxisDirection direction;
  final Duration duration;

  SlidePageRoute({
    required this.page,
    this.direction = AxisDirection.right,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
         transitionDuration: duration,
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           Offset begin;
           switch (direction) {
             case AxisDirection.up:
               begin = const Offset(0, 1);
               break;
             case AxisDirection.down:
               begin = const Offset(0, -1);
               break;
             case AxisDirection.left:
               begin = const Offset(1, 0);
               break;
             case AxisDirection.right:
               begin = const Offset(-1, 0);
               break;
           }

           const end = Offset.zero;
           var tween = Tween(
             begin: begin,
             end: end,
           ).chain(CurveTween(curve: Curves.ease));

           return SlideTransition(
             position: animation.drive(tween),
             child: child,
           );
         },
       );
}

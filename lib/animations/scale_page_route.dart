import 'package:flutter/material.dart';

class ScalePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;

  ScalePageRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
         transitionDuration: duration,
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           var tween = Tween(
             begin: 0.0,
             end: 1.0,
           ).chain(CurveTween(curve: Curves.easeInOut));

           return ScaleTransition(scale: animation.drive(tween), child: child);
         },
       );
}

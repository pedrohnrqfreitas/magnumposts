import 'package:flutter/material.dart';

enum PageTransitionType {
  fade,
  slide,
  scale,
  rotation,
}

class AnimatedPageTransition extends PageRouteBuilder {
  final Widget page;
  final PageTransitionType transitionType;
  final Duration duration;

  AnimatedPageTransition({
    required this.page,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return _buildTransition(
        transitionType,
        animation,
        secondaryAnimation,
        child,
      );
    },
  );

  static Widget _buildTransition(
      PageTransitionType type,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    switch (type) {
      case PageTransitionType.fade:
        return FadeTransition(opacity: animation, child: child);

      case PageTransitionType.slide:
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );

      case PageTransitionType.scale:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );

      case PageTransitionType.rotation:
        return RotationTransition(
          turns: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
    }
  }
}
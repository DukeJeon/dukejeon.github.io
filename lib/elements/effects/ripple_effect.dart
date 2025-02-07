import 'dart:async';

import 'package:dukejeon_github_io/elements/values/palette.dart';
import 'package:flutter/material.dart';

class RippleEffect extends StatefulWidget {
  const RippleEffect({super.key});

  @override
  State<RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect> with TickerProviderStateMixin{

  final List<AnimationController> animations = [];
  List<Animation<double>> curvedAnimations = [];
  final int length = 5;
  final double upperBound = 0.03;
  
  @override
  void initState() {
    super.initState();
    for (int index = 0; index < length; index++) {
      animations.add(
        AnimationController(
          vsync: this,
          duration: const Duration(seconds: 2),
        )
      );
    }

    for (var animation in animations) {
      curvedAnimations.add(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut
        )
      );
    }
    forwardFloatingAnimations();
  }

  Future<void> forwardFloatingAnimations() async {
    Completer floating = Completer();
    for (var element in animations) {
      element.value = 0;
    }

    for (var element in animations) {
      int index = animations.indexOf(element);
      Completer completer = Completer();

      element.addListener(() {
        endStep(index, element, completer);
      });

      element.forward().then((value) {
        if (!completer.isCompleted) {
          completer.complete();
        }

        element.removeListener(() {
          endStep(index, element, completer);
        });

        if (animations.last == element) {
          floating.complete();
        }
      });

      await completer.future;
    }
    await floating.future;
    forwardFloatingAnimations();
  }

  void endStep(int index, AnimationController element, Completer<dynamic> completer) {
    if (element.value > upperBound + index * 0.1) {
      if (animations.last != element) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    }
  }

  @override
  void dispose() {
    for (var controller in animations) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(animations),
      builder: (context, child) {
        return Stack(
          children: curvedAnimations.map((controller) {
            return CustomPaint(
              painter: RipplePainter(controller.value),
              child: Container(),
            );
          }).toList()
        );
      },
    );
  }
}

class RipplePainter extends CustomPainter {
  final double progress;
  RipplePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Palette.secondaryColor.withValues(alpha: 1 - progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    final double maxRadius = size.width * 0.5;
    final double radius = maxRadius * progress;

    canvas.drawCircle(size.center(Offset.zero), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
import 'package:flutter/material.dart';
import 'package:frontend/core/animation/animation_enum.dart';

class AnimationService extends StatefulWidget {
  final Widget child;
  final AnimationType type;
  final Duration duration;
  final Curve curve;
  final Duration delay;
  final bool repeat;
  final SlideDirection slideDirection;

  const AnimationService({
    super.key,
    required this.child,
    required this.type,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
    this.delay = Duration.zero,
    this.repeat = false,
    this.slideDirection = SlideDirection.up,
  });

  @override
  State<AnimationService> createState() => _AnimationServiceState();
}

class _AnimationServiceState extends State<AnimationService>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;
  late Animation<double> _rotation;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    final curved = CurvedAnimation(parent: _controller, curve: widget.curve);

    // Fade
    _opacity = Tween<double>(begin: 0, end: 1).animate(curved);

    // Scale
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(curved);

    // Rotation
    _rotation = Tween<double>(begin: -0.5, end: 0).animate(curved);

    // Slide
    Offset beginOffset;
    switch (widget.slideDirection) {
      case SlideDirection.left:
        beginOffset = const Offset(-1, 0);
        break;
      case SlideDirection.right:
        beginOffset = const Offset(1, 0);
        break;
      case SlideDirection.up:
        beginOffset = const Offset(0, 1);
        break;
      case SlideDirection.down:
        beginOffset = const Offset(0, -1);
        break;
    }
    _slide = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(curved);

    // Delay before animation starts
    Future.delayed(widget.delay, () {
      if (mounted) {
        if (widget.repeat) {
          _controller.repeat(reverse: true);
        } else {
          _controller.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        switch (widget.type) {
          case AnimationType.fade:
            return Opacity(opacity: _opacity.value, child: child);

          case AnimationType.slide:
            return SlideTransition(position: _slide, child: child);

          case AnimationType.scale:
            return Transform.scale(scale: _scale.value, child: child);

          case AnimationType.rotate:
            return Transform.rotate(angle: _rotation.value, child: child);

          case AnimationType.combined:
            return Opacity(
              opacity: _opacity.value,
              child: Transform.translate(
                offset: _slide.value * 100,
                child: Transform.scale(
                  scale: _scale.value,
                  child: Transform.rotate(angle: _rotation.value, child: child),
                ),
              ),
            );
        }
      },
    );
  }
}

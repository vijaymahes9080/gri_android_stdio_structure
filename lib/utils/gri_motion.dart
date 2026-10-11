import 'package:flutter/material.dart';

/// GRI Motion & Animation Design System
/// Built in accordance with Emil Kowalski's animation philosophy:
/// - Context-aware timing (100-200ms micro, 250-350ms component reveals)
/// - Physics-based natural easing (Cubic(0.16, 1.0, 0.3, 1.0))
/// - Spatial continuity and non-jarring state transitions
/// - Reduced-motion accessibility compliance
class GriMotion {
  // 1. Natural Easing Curves
  static const Curve easeOutCubic = Cubic(0.16, 1.0, 0.3, 1.0); // Natural deceleration
  static const Curve easeInOutCubic = Cubic(0.65, 0.0, 0.35, 1.0); // Symmetrical smooth
  static const Curve snappySpring = Cubic(0.2, 0.8, 0.2, 1.0); // Tactile micro-interactions

  // 2. Purposeful Duration Scales
  static const Duration micro = Duration(milliseconds: 150); // Hovers, taps, toggles
  static const Duration quick = Duration(milliseconds: 220); // Quick state transitions
  static const Duration standard = Duration(milliseconds: 320); // Card reveals, modals, tabs
  static const Duration entrance = Duration(milliseconds: 400); // Page & hero reveals

  // Stagger delays for lists
  static const Duration staggerDelay = Duration(milliseconds: 45);

  /// Helper to check if reduced motion is requested
  static bool shouldReduceMotion(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }
}

/// Tactile press scale feedback widget for cards and buttons
class GriPressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  final BorderRadius? borderRadius;

  const GriPressable({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.97,
    this.borderRadius,
  });

  @override
  State<GriPressable> createState() => _GriPressableState();
}

class _GriPressableState extends State<GriPressable> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: GriMotion.micro,
      reverseDuration: GriMotion.micro,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressedScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: GriMotion.snappySpring,
      reverseCurve: GriMotion.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    if (widget.onTap != null) _controller.forward();
  }

  void _handleTapUp(TapUpDetails _) {
    if (widget.onTap != null) _controller.reverse();
  }

  void _handleTapCancel() {
    if (widget.onTap != null) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (GriMotion.shouldReduceMotion(context) || widget.onTap == null) {
      return InkWell(
        onTap: widget.onTap,
        borderRadius: widget.borderRadius,
        child: widget.child,
      );
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: widget.child,
      ),
    );
  }
}

/// Fluid entrance animation with subtle slide-up and fade-in
class GriFadeSlideEntrance extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset slideOffset;

  const GriFadeSlideEntrance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = GriMotion.standard,
    this.slideOffset = const Offset(0.0, 0.08),
  });

  @override
  State<GriFadeSlideEntrance> createState() => _GriFadeSlideEntranceState();
}

class _GriFadeSlideEntranceState extends State<GriFadeSlideEntrance>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: GriMotion.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(begin: widget.slideOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: GriMotion.easeOutCubic),
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (GriMotion.shouldReduceMotion(context)) {
      return widget.child;
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

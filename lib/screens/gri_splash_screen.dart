import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';
import '../services/official_resource_registry.dart';
import '../main.dart';

/// Authentic Institutional Animated Splash Screen
/// Showcases official university seal, bilingual title, NAAC accreditation, and motto.
class GriSplashScreen extends StatefulWidget {
  const GriSplashScreen({super.key});

  @override
  State<GriSplashScreen> createState() => _GriSplashScreenState();
}

class _GriSplashScreenState extends State<GriSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();

    // Navigate smoothly to MainScaffold after authentic introduction
    _timer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const MainScaffold(),
            transitionDuration: GriMotion.standard,
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),

                        // University Official Emblem / Seal
                        Container(
                          width: 110,
                          height: 110,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color: GriColors.forestPrimary.withValues(alpha: 0.2),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: GriColors.forestPrimary.withValues(alpha: 0.12),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: OfficialResourceRegistry.buildImage(
                              "IMG_OFFICIAL_CREST",
                              width: 98,
                              height: 98,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Bilingual Tamil Title
                        const Text(
                          "காந்திகிராம கிராமிய நிறுவனம்",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: GriColors.forestPrimary,
                            letterSpacing: 0.3,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 4),

                        // Official English Title
                        Text(
                          "THE GANDHIGRAM RURAL INSTITUTE",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 6),

                        // Status & Statutory Subtitle
                        Text(
                          "(Deemed to be University)",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                            letterSpacing: 0.2,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Accreditation Badge Pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: GriColors.forestPrimary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: GriColors.forestPrimary.withValues(alpha: 0.25),
                              width: 1.0,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.workspace_premium, color: GriColors.ochrePrimary, size: 16),
                              SizedBox(width: 6),
                              Text(
                                "NAAC 'A' Grade  •  Estd. 1956  •  MoE, Govt. of India",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: GriColors.forestPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        // Subtitle / Motto
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Text(
                            "Inspired by Mahatma Gandhi & Dr. G. Ramachandran\nNai Talim • Work-Centred Education",
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                              height: 1.4,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

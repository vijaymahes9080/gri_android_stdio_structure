import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'gri_colors.dart';

/// Centralized, high-resilience URL and external intent launcher.
/// Resolves Android 11+ package visibility limitations by cascading through
/// LaunchMode.externalApplication, LaunchMode.platformDefault, and LaunchMode.inAppBrowserView.
class GriUrlLauncher {
  static Future<bool> launch(BuildContext? context, String urlString) async {
    final cleanUrl = urlString.trim();
    if (cleanUrl.isEmpty) return false;

    final uri = Uri.tryParse(cleanUrl);
    if (uri == null) {
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Invalid URL: $cleanUrl"),
            backgroundColor: GriColors.error,
          ),
        );
      }
      return false;
    }

    // 1. Attempt LaunchMode.externalApplication (default system browser / dialer / mail client)
    try {
      final success = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (success) return true;
    } catch (_) {
      // Continue to next fallback mode
    }

    // 2. Fallback to platformDefault
    try {
      final success = await launchUrl(uri, mode: LaunchMode.platformDefault);
      if (success) return true;
    } catch (_) {
      // Continue to next fallback mode
    }

    // 3. Fallback to inAppBrowserView for web URLs
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      try {
        final success = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
        if (success) return true;
      } catch (_) {
        // Fallback exhausted
      }
    }

    // Inform user only if all attempts failed
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Could not launch browser for: $cleanUrl"),
          backgroundColor: GriColors.error,
        ),
      );
    }
    return false;
  }
}

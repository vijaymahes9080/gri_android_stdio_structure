import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/verified_institution_content.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_motion.dart';
import '../utils/gri_url_launcher.dart';

/// Official contact and campus location information.
///
/// Only values published by GRI are shown. Previous versions listed invented
/// department email addresses, internal EPABX extensions and emergency numbers;
/// those have been removed rather than guessed. Users are routed to the official
/// contact page for anything that is not published here.
class ContactCampusInfoScreen extends StatelessWidget {
  const ContactCampusInfoScreen({super.key});

  Future<void> _call(BuildContext context, String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      await Clipboard.setData(ClipboardData(text: number));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone number copied: $number')),
        );
      }
    }
  }

  Future<void> _mail(BuildContext context, String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      await Clipboard.setData(ClipboardData(text: email));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email copied: $email')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text('Contact & Campus Location'),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Open official contact page',
            icon: const Icon(Icons.public),
            onPressed: () =>
                GriUrlLauncher.launch(context, VerifiedInstitution.contactUrl),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          _card(
            context,
            isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'THE GANDHIGRAM RURAL INSTITUTE',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Deemed to be University • ${VerifiedInstitution.accreditation}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? GriColors.darkOnSurfaceVariant
                        : GriColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                _infoRow(
                  context,
                  isDark,
                  Icons.location_on_outlined,
                  VerifiedInstitution.address,
                  null,
                ),
                _infoRow(
                  context,
                  isDark,
                  Icons.phone_outlined,
                  VerifiedInstitution.phone,
                  () => _call(context, VerifiedInstitution.phone),
                ),
                _infoRow(
                  context,
                  isDark,
                  Icons.email_outlined,
                  VerifiedInstitution.email,
                  () => _mail(context, VerifiedInstitution.email),
                ),
                _infoRow(
                  context,
                  isDark,
                  Icons.public,
                  'www.ruraluniv.ac.in',
                  () => GriUrlLauncher.launch(
                      context, VerifiedInstitution.website),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _card(
            context,
            isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(isDark, 'CAMPUS LOCATION'),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      VerifiedInstitution.campusMapImageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (_, child, progress) => progress == null
                          ? child
                          : Container(
                              color: GriColors.forestPrimary.withValues(alpha: 0.06),
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            ),
                      errorBuilder: (_, __, ___) => Container(
                        color: GriColors.forestPrimary.withValues(alpha: 0.08),
                        child: const Center(
                          child: Text(
                            'Official campus map image unavailable.\n'
                            'Open it in the browser using the button below.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'GRI publishes its campus map as an image. Building-level GPS '
                  'coordinates are not published, so this app does not place '
                  'its own pins.',
                  style: TextStyle(
                    fontSize: 10.5,
                    height: 1.4,
                    color: isDark
                        ? GriColors.darkOnSurfaceVariant
                        : GriColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _action(
                        context,
                        icon: Icons.map_outlined,
                        label: 'Official map',
                        onTap: () => GriUrlLauncher.launch(
                            context, VerifiedInstitution.campusMapImageUrl),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _action(
                        context,
                        icon: Icons.navigation_outlined,
                        label: 'Google Maps',
                        onTap: () => GriUrlLauncher.launch(
                            context, VerifiedInstitution.googleMapsUrl),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _card(
            context,
            isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(isDark, 'STUDENT SUPPORT & COMPLIANCE'),
                const SizedBox(height: 4),
                _linkRow(
                  context,
                  isDark,
                  'Student grievance redressal & Ombudsperson',
                  VerifiedInstitution.grievanceCircularUrl,
                ),
                _linkRow(
                  context,
                  isDark,
                  'Anti-ragging information (official page)',
                  'https://www.ruraluniv.ac.in/page/cells#anti-ragging',
                ),
                _linkRow(
                  context,
                  isDark,
                  'National Anti-Ragging Helpline (antiragging.in)',
                  'https://www.antiragging.in/',
                ),
                _linkRow(
                  context,
                  isDark,
                  'Official FAQ',
                  VerifiedInstitution.faqUrl,
                ),
                _linkRow(
                  context,
                  isDark,
                  'Official feedback form',
                  VerifiedInstitution.feedbackUrl,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Department-specific phone numbers and email addresses are published '
            'on each official GRI page. This app does not invent contact details; '
            'use the official contact page for the current directory.',
            style: TextStyle(
              fontSize: 10.5,
              height: 1.45,
              color:
                  isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, bool isDark, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface1 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
        ),
      ),
      child: child,
    );
  }

  Widget _sectionTitle(bool isDark, String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.5,
        color: GriColors.forestPrimary,
      ),
    );
  }

  Widget _infoRow(
    BuildContext context,
    bool isDark,
    IconData icon,
    String text,
    VoidCallback? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: GriColors.forestPrimary),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.35,
                  color: isDark ? GriColors.darkOnSurface : GriColors.onSurface,
                ),
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                size: 16,
                color: isDark
                    ? GriColors.darkOnSurfaceVariant
                    : GriColors.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }

  Widget _linkRow(BuildContext context, bool isDark, String label, String url) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(label, style: const TextStyle(fontSize: 12.5)),
      trailing: const Icon(Icons.open_in_new, size: 15),
      onTap: () => GriUrlLauncher.launch(context, url),
    );
  }

  Widget _action(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GriPressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: GriColors.forestPrimary.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: GriColors.forestPrimary.withValues(alpha: 0.22),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: GriColors.forestPrimary),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: GriColors.forestPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

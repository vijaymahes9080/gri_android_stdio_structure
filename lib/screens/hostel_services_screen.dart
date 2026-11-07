import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/gri_provider.dart';
import '../services/verified_institution_content.dart';
import '../utils/gri_colors.dart';
import '../utils/gri_url_launcher.dart';
import '../widgets/gri_primitives.dart';

/// Verified public hostel services information plus an honest enquiry workflow.
///
/// GRI publishes hostel and residential facilities on its official
/// infrastructure page, but does not publish room allocations, allotment
/// status, or maintenance-tracking records in the data available to this app.
/// This screen therefore shows only verified public information and a clearly
/// labelled enquiry path. No room availability or allocation data is invented.
class HostelServicesScreen extends StatelessWidget {
  const HostelServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<GriProvider>();
    final residential = VerifiedContent.facilities
        .where((f) => f.category == 'Residential')
        .toList();

    return Scaffold(
      backgroundColor: isDark ? GriColors.darkCanvas : GriColors.surfaceCanvas,
      appBar: AppBar(
        title: const Text('Hostel Services'),
        backgroundColor: isDark ? GriColors.darkSurface1 : Colors.white,
        foregroundColor: isDark ? GriColors.darkOnSurface : GriColors.forestPrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        children: [
          GriSectionHeader(
            title: 'Residential facilities',
            actionLabel: null,
          ),
          const SizedBox(height: 8),
          if (residential.isEmpty)
            GriEmptyState(
              icon: Icons.apartment_outlined,
              title: 'No residential facilities published',
              hint: 'Hostel information is not available in the verified dataset.',
            )
          else
            ...residential.map((f) => _facilityCard(context, isDark, f)),

          const SizedBox(height: 20),
          GriSectionHeader(
            title: 'Hostel enquiry',
            actionLabel: null,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? GriColors.darkSurface1 : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
                width: 0.8,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hostel allotment and administration',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  'Hostel allotment, mess rules, fee details and maintenance '
                  'requests are administered by GRI. This app does not display '
                  'official allotment records and cannot submit applications on '
                  'your behalf.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        GriUrlLauncher.launch(context, VerifiedInstitution.infrastructureUrl),
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: const Text('Official infrastructure page'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: provider.currentRole == UserRole.STUDENT &&
                            !provider.isStudentWorkspaceUnlocked
                        ? null
                        : () => _showEnquiryNotice(context, isDark),
                    icon: const Icon(Icons.email_outlined, size: 16),
                    label: const Text('Send enquiry (demo workspace)'),
                  ),
                ),
                if (provider.currentRole == UserRole.STUDENT &&
                    !provider.isStudentWorkspaceUnlocked)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Unlock the student workspace to use the enquiry form. '
                      'This build has no live university session, so enquiries '
                      'are not transmitted to the university.',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _facilityCard(BuildContext context, bool isDark, VerifiedFacility facility) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? GriColors.darkSurface1 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? GriColors.darkOutlineVariant : GriColors.outlineVariant,
          width: 0.8,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: GriColors.forestPrimary.withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.apartment_outlined,
            size: 20,
            color: GriColors.forestPrimary,
          ),
        ),
        title: Text(
          facility.name,
          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            'Verified public information • official GRI source',
            style: TextStyle(
              fontSize: 10.5,
              color: isDark ? GriColors.darkOnSurfaceVariant : GriColors.onSurfaceVariant,
            ),
          ),
        ),
        trailing: const Icon(Icons.open_in_new, size: 18),
        onTap: () => GriUrlLauncher.launch(context, facility.sourceUrl),
      )),
    );
  }

  void _showEnquiryNotice(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hostel enquiry — demo workspace'),
        content: const Text(
          'This build has no authorised live university session. A hostel '
          'enquiry submitted here is a local demo action only — it does not '
          'reach the university hostel office.\n\nFor real hostel allotment, '
          'mess or maintenance requests, contact the Chief Warden’s office or '
          'use the official infrastructure page linked above.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/gri_provider.dart';
import 'models/user_model.dart';
import 'utils/gri_colors.dart';
import 'widgets/gri_top_bar.dart';
import 'widgets/role_switcher_modal.dart';
import 'widgets/registration_wizard_modal.dart';
import 'widgets/admin_review_modal.dart';
import 'widgets/hall_ticket_modal.dart';
import 'screens/home_dashboard_screen.dart';
import 'screens/academics_hub_screen.dart';
import 'screens/campus_facilities_screen.dart';
import 'screens/student_services_hub_screen.dart';
import 'screens/admin_directory_screen.dart';
import 'screens/admin_approval_center_screen.dart';
import 'screens/application_status_screen.dart';
import 'screens/ask_gri_ai_screen.dart';
import 'screens/official_document_center_screen.dart';
import 'screens/faculty_staff_portal_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => GriProvider(),
      child: const GriApplication(),
    ),
  );
}

class GriApplication extends StatelessWidget {
  const GriApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Gandhigram Rural Institute',
      debugShowCheckedModeBanner: false,
      theme: GriColors.lightTheme,
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatelessWidget {
  const MainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GriProvider>();
    final isApproved = provider.activeAccountStatus == AccountStatus.APPROVED;

    // Listen for notifications
    if (provider.notificationMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.notificationMessage!),
            backgroundColor: GriColors.forestPrimary,
            duration: const Duration(seconds: 2),
          ),
        );
        provider.clearNotification();
      });
    }

    // Dynamic Navigation Items based on Role
    final List<_NavItem> navItems;
    if (!isApproved) {
      navItems = [
        _NavItem(NavigationTab.STATUS, "Status", Icons.hourglass_top),
        _NavItem(NavigationTab.CAMPUS, "Campus", Icons.domain),
        _NavItem(NavigationTab.MORE, "More", Icons.menu),
      ];
    } else if (provider.currentRole == UserRole.ADMIN || provider.currentRole == UserRole.SUPER_ADMIN) {
      navItems = [
        _NavItem(NavigationTab.HOME, "Home", Icons.home),
        _NavItem(NavigationTab.APPROVALS, "Approvals", Icons.fact_check),
        _NavItem(NavigationTab.ACADEMICS, "Academics", Icons.school),
        _NavItem(NavigationTab.SERVICES, "Services", Icons.grid_view),
        _NavItem(NavigationTab.MORE, "More", Icons.menu),
      ];
    } else if (provider.currentRole == UserRole.COE_STAFF) {
      navItems = [
        _NavItem(NavigationTab.HOME, "Home", Icons.home),
        _NavItem(NavigationTab.EXAMS, "Exams", Icons.fact_check),
        _NavItem(NavigationTab.ACADEMICS, "Academics", Icons.school),
        _NavItem(NavigationTab.SERVICES, "Services", Icons.grid_view),
        _NavItem(NavigationTab.MORE, "More", Icons.menu),
      ];
    } else if (provider.currentRole == UserRole.SCHOLAR) {
      navItems = [
        _NavItem(NavigationTab.HOME, "Home", Icons.home),
        _NavItem(NavigationTab.RESEARCH, "Research", Icons.science),
        _NavItem(NavigationTab.ACADEMICS, "Academics", Icons.school),
        _NavItem(NavigationTab.SERVICES, "Services", Icons.grid_view),
        _NavItem(NavigationTab.MORE, "More", Icons.menu),
      ];
    } else if (provider.currentRole == UserRole.FACULTY) {
      navItems = [
        _NavItem(NavigationTab.HOME, "Home", Icons.home),
        _NavItem(NavigationTab.ACADEMICS, "Academics", Icons.school),
        _NavItem(NavigationTab.SERVICES, "Services", Icons.grid_view),
        _NavItem(NavigationTab.CAMPUS, "Campus", Icons.domain),
        _NavItem(NavigationTab.MORE, "More", Icons.menu),
      ];
    } else {
      // Default (STUDENT)
      navItems = [
        _NavItem(NavigationTab.HOME, "Home", Icons.home),
        _NavItem(NavigationTab.ACADEMICS, "Academics", Icons.school),
        _NavItem(NavigationTab.CAMPUS, "Campus", Icons.domain),
        _NavItem(NavigationTab.SERVICES, "Services", Icons.grid_view),
        _NavItem(NavigationTab.MORE, "More", Icons.menu),
      ];
    }

    // Determine Active Screen
    Widget activeScreen;
    if (!isApproved) {
      activeScreen = const ApplicationStatusScreen();
    } else {
      switch (provider.currentTab) {
        case NavigationTab.HOME:
          activeScreen = const HomeDashboardScreen();
          break;
        case NavigationTab.ACADEMICS:
        case NavigationTab.EXAMS:
          activeScreen = const AcademicsHubScreen();
          break;
        case NavigationTab.APPROVALS:
          activeScreen = const AdminApprovalCenterScreen();
          break;
        case NavigationTab.CAMPUS:
          activeScreen = const CampusFacilitiesScreen();
          break;
        case NavigationTab.SERVICES:
          activeScreen = const StudentServicesHubScreen();
          break;
        case NavigationTab.RESEARCH:
          activeScreen = const OfficialDocumentCenterScreen();
          break;
        case NavigationTab.STATUS:
          activeScreen = const ApplicationStatusScreen();
          break;
        case NavigationTab.MORE:
          activeScreen = const AdminDirectoryScreen();
          break;
      }
    }

    // Safe index for bottom navigation
    int selectedNavIndex = navItems.indexWhere((item) => item.tab == provider.currentTab);
    if (selectedNavIndex == -1) selectedNavIndex = 0;

    return Stack(
      children: [
        Scaffold(
          appBar: const GriTopBar(),
          body: activeScreen,
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedNavIndex,
            backgroundColor: Colors.white,
            indicatorColor: GriColors.forestPrimary.withOpacity(0.12),
            onDestinationSelected: (index) {
              provider.switchTab(navItems[index].tab);
            },
            destinations: navItems
                .map((item) => NavigationDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.icon, color: GriColors.forestPrimary),
                      label: item.title,
                    ))
                .toList(),
          ),
        ),

        // Modal: Role Switcher
        if (provider.isRoleSwitcherOpen)
          ModalBarrier(
            color: Colors.black54,
            dismissible: true,
            onDismiss: () => provider.toggleRoleSwitcher(false),
          ),
        if (provider.isRoleSwitcherOpen)
          const Align(
            alignment: Alignment.bottomCenter,
            child: RoleSwitcherModal(),
          ),

        // Modal: Registration Wizard
        if (provider.isRegistrationWizardOpen)
          const RegistrationWizardModal(),

        // Modal: Admin Review Dossier
        if (provider.isAdminReviewOpen)
          const AdminReviewModal(),

        // Modal: Examination Hall Ticket
        if (provider.hallTicketData != null)
          const HallTicketModal(),

        // Modal Dialog: Ask GRI AI Assistant
        if (provider.isAskAiOpen)
          Dialog(
            insetPadding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: SizedBox(
              width: 580,
              height: 650,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          "GRI-Sahayak AI Assistant",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: GriColors.forestPrimary),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => provider.toggleAskAi(false),
                      ),
                    ],
                  ),
                  const Divider(height: 1),
                  const Expanded(child: AskGriAiScreen()),
                ],
              ),
            ),
          ),

        // Modal Dialog: Official Document Center
        if (provider.isDocumentCenterOpen)
          Dialog(
            insetPadding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: SizedBox(
              width: 580,
              height: 650,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          "Official Document Center",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: GriColors.forestPrimary),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => provider.toggleDocumentCenter(false),
                      ),
                    ],
                  ),
                  const Divider(height: 1),
                  const Expanded(child: OfficialDocumentCenterScreen()),
                ],
              ),
            ),
          ),

        // Modal Dialog: Faculty Portal
        if (provider.isFacultyPortalOpen)
          Dialog(
            insetPadding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: SizedBox(
              width: 580,
              height: 650,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          "Faculty & Staff Academic Portal",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: GriColors.forestPrimary),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => provider.toggleFacultyPortal(false),
                      ),
                    ],
                  ),
                  const Divider(height: 1),
                  const Expanded(child: FacultyStaffPortalScreen()),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _NavItem {
  final NavigationTab tab;
  final String title;
  final IconData icon;

  _NavItem(this.tab, this.title, this.icon);
}

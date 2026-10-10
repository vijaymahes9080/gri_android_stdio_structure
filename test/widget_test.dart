import 'package:flutter_test/flutter_test.dart';
import 'package:gri_app/main.dart';
import 'package:gri_app/providers/gri_provider.dart';
import 'package:gri_app/models/user_model.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('GRI App renders dashboard and title successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GriProvider(),
        child: const GriApplication(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify institutional title exists
    expect(find.text('THE GANDHIGRAM RURAL INSTITUTE'), findsOneWidget);
  });

  test('GRI Provider initializes with default student role and courses', () {
    final provider = GriProvider();
    expect(provider.currentRole, UserRole.STUDENT);
    expect(provider.courses.isNotEmpty, true);
    expect(provider.circulars.isNotEmpty, true);
    expect(provider.availableAccounts.isNotEmpty, true);
  });

  test('GRI Provider handles attendance marking and percentage calculation', () {
    final provider = GriProvider();
    final firstCourse = provider.courses.first;
    final initialAttended = firstCourse.attendedClasses;

    provider.markAttendance(firstCourse.id);

    final updatedCourse = provider.courses.firstWhere((c) => c.id == firstCourse.id);
    expect(updatedCourse.attendedClasses, initialAttended + 1);
  });

  test('GRI Provider switches authorized role correctly', () {
    final provider = GriProvider();
    provider.switchAuthorizedRole(UserRole.FACULTY);

    expect(provider.currentRole, UserRole.FACULTY);
  });

  test('GRI Provider submits new grievance', () {
    final provider = GriProvider();
    final initialCount = provider.grievances.length;

    provider.submitGrievance("Transport", "Bus Delaybat", "Batlagundu bus delay 15 min");

    expect(provider.grievances.length, initialCount + 1);
    expect(provider.grievances.first.subject, "Bus Delaybat");
  });
}

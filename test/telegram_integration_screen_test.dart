import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gri_app/providers/gri_provider.dart';
import 'package:gri_app/screens/telegram_integration_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('TelegramIntegrationScreen renders connection card, bot identity, and gating info',
      (WidgetTester tester) async {
    final provider = GriProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<GriProvider>.value(
        value: provider,
        child: const MaterialApp(
          home: TelegramIntegrationScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify key titles and bot identity
    expect(find.text('TELEGRAM BOT INTEGRATION'), findsOneWidget);
    expect(find.text('@Gandhigram_rural_institutebot'), findsOneWidget);
    expect(find.text('ROLE-BASED TELEGRAM GATING (STUDENT)'), findsOneWidget);
    expect(find.text('NOTIFICATION DELIVERY CHANNELS'), findsOneWidget);
    expect(find.text('MESSAGE & DELIVERY LEDGER'), findsOneWidget);
  });
}

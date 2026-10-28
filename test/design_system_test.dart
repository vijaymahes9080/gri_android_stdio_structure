import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gri_app/utils/gri_colors.dart';
import 'package:gri_app/utils/gri_metrics.dart';
import 'package:gri_app/utils/gri_motion.dart';
import 'package:gri_app/utils/gri_typography.dart';
import 'package:gri_app/widgets/gri_primitives.dart';

void main() {
  group('Typography system', () {
    test('every text role is assigned and respects the 10px legibility floor',
        () {
      final theme = GriTypography.theme(Brightness.light);
      final roles = [
        theme.displayLarge, theme.displayMedium,
        theme.headlineLarge, theme.headlineMedium, theme.headlineSmall,
        theme.titleLarge, theme.titleMedium, theme.titleSmall,
        theme.bodyLarge, theme.bodyMedium, theme.bodySmall,
        theme.labelLarge, theme.labelMedium, theme.labelSmall,
      ];
      expect(roles.every((s) => s != null), isTrue);
      expect(
        roles.every((s) => s!.fontSize != null && s.fontSize! >= 10),
        isTrue,
        reason: 'No tokenized style may sit below the 10px legibility floor',
      );
    });

    test('dark mode re-inks the same typographic geometry', () {
      final light = GriColors.lightTheme.textTheme;
      final dark = GriColors.darkTheme.textTheme;

      // Geometry parity: identical sizes across brightness for sampled roles.
      expect(dark.displayLarge?.fontSize, light.displayLarge?.fontSize,
          reason: 'displayLarge size parity');
      expect(dark.bodyMedium?.fontSize, light.bodyMedium?.fontSize,
          reason: 'bodyMedium size parity');
      expect(dark.labelSmall?.fontSize, light.labelSmall?.fontSize,
          reason: 'labelSmall size parity');

      // Ink parity: dark surfaces get dark-appropriate ink, not light ink.
      expect(dark.displayLarge!.color, GriColors.darkOnSurface);
      expect(dark.bodySmall!.color, GriColors.darkOnSurfaceVariant);
      expect(light.displayLarge!.color, GriColors.onSurface);
      expect(light.bodySmall!.color, GriColors.onSurfaceVariant);
    });
  });

  group('Component themes', () {
    test('light theme defines buttons, inputs, dialogs, sheets and nav bar',
        () {
      final theme = GriColors.lightTheme;

      final button = theme.elevatedButtonTheme.style!;
      expect(button.minimumSize?.resolve({}), const Size(88, 48));
      expect(
        button.foregroundColor?.resolve({WidgetState.disabled}),
        GriColors.onSurface.withValues(alpha: 0.38),
      );

      final input = theme.inputDecorationTheme;
      expect(input.filled, isTrue);
      expect(input.fillColor, GriColors.surfaceVariant);
      expect(input.focusedBorder?.borderSide.color, GriColors.forestPrimary);

      expect(theme.dialogTheme.shape, isA<RoundedRectangleBorder>());
      expect(
        (theme.dialogTheme.shape as RoundedRectangleBorder).borderRadius,
        BorderRadius.circular(GriRadii.xl),
      );
      expect(theme.snackBarTheme.behavior, SnackBarBehavior.floating);

      final sheetShape =
          theme.bottomSheetTheme.shape as RoundedRectangleBorder;
      expect(
        sheetShape.borderRadius,
        const BorderRadius.vertical(top: Radius.circular(GriRadii.sheet)),
      );

      expect(theme.navigationBarTheme.height, 64);
      expect(theme.navigationBarTheme.indicatorColor,
          GriColors.forestPrimary.withValues(alpha: 0.14));
    });

    test('dark theme mirrors every component theme with dark values', () {
      final theme = GriColors.darkTheme;

      expect(theme.textTheme.displayLarge, isNotNull);
      final input = theme.inputDecorationTheme;
      expect(input.fillColor, GriColors.darkSurface2);
      expect(input.focusedBorder?.borderSide.color, const Color(0xFF81C784));

      expect(theme.dialogTheme.backgroundColor, GriColors.darkSurface3);
      expect(theme.snackBarTheme.backgroundColor, GriColors.darkSurface3);
      expect(theme.bottomSheetTheme.backgroundColor, GriColors.darkSurface1);
      expect(theme.navigationBarTheme.backgroundColor, GriColors.darkSurface1);

      final button = theme.elevatedButtonTheme.style!;
      expect(button.backgroundColor?.resolve({}), const Color(0xFF81C784));
      expect(button.foregroundColor?.resolve({}), const Color(0xFF003A08));
    });
  });

  group('Shared primitives', () {
    Widget host(Widget child, {Brightness brightness = Brightness.light}) {
      return MaterialApp(
        theme: brightness == Brightness.light
            ? GriColors.lightTheme
            : GriColors.darkTheme,
        home: Scaffold(body: child),
      );
    }

    testWidgets('GriEmptyState renders icon, title and hint', (tester) async {
      await tester.pumpWidget(host(const GriEmptyState(
        icon: Icons.inbox_outlined,
        title: 'No applications found',
        hint: 'Adjust the filter to see more.',
      )));
      expect(find.text('No applications found'), findsOneWidget);
      expect(find.text('Adjust the filter to see more.'), findsOneWidget);
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });

    testWidgets('GriSectionHeader uppercases and exposes its action',
        (tester) async {
      var taps = 0;
      await tester.pumpWidget(host(GriSectionHeader(
        title: 'Available roles',
        actionLabel: 'Manage',
        onAction: () => taps++,
      )));
      expect(find.text('AVAILABLE ROLES'), findsOneWidget);
      expect(find.text('Manage'), findsOneWidget);

      await tester.tap(find.text('Manage'));
      expect(taps, 1);
    });

    testWidgets('GriStatusBadge uses success tokens in light mode',
        (tester) async {
      await tester.pumpWidget(host(const GriStatusBadge(
        label: 'APPROVED',
        tone: GriStatusTone.success,
      )));
      final container = tester.widget<Container>(
        find.byType(Container),
      );
      expect(
        (container.decoration as BoxDecoration).color,
        GriColors.successContainer,
      );
      expect(find.text('APPROVED'), findsOneWidget);
    });

    testWidgets('GriStatusBadge re-inks with bright tokens in dark mode',
        (tester) async {
      await tester.pumpWidget(host(
        const GriStatusBadge(label: 'APPROVED', tone: GriStatusTone.success),
        brightness: Brightness.dark,
      ));
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, GriColors.successBright.withValues(alpha: 0.16));
      expect(
        (container.decoration as BoxDecoration).border!.top.color,
        GriColors.successBright.withValues(alpha: 0.35),
      );
    });
  });

  group('Motion accessibility', () {
    testWidgets('entrance animations are bypassed when reduced motion is on',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: GriColors.lightTheme,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(disableAnimations: true),
          child: child ?? const SizedBox.shrink(),
        ),
        home: const Scaffold(
          body: GriFadeSlideEntrance(
            child: Text('Instant content'),
          ),
        ),
      ));

      // Reduced motion: the entrance widget returns its child directly —
      // no FadeTransition may exist INSIDE it (the app-level page transition
      // fade lives outside and is irrelevant).
      expect(
        find.descendant(
          of: find.byType(GriFadeSlideEntrance),
          matching: find.byType(FadeTransition),
        ),
        findsNothing,
      );
    });

    testWidgets('entrance animations run (with a FadeTransition) by default',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: GriColors.lightTheme,
        home: const Scaffold(
          body: GriFadeSlideEntrance(
            child: Text('Animated content'),
          ),
        ),
      ));
      await tester.pump();
      expect(
        find.descendant(
          of: find.byType(GriFadeSlideEntrance),
          matching: find.byType(FadeTransition),
        ),
        findsOneWidget,
      );
      await tester.pumpAndSettle();
      expect(find.text('Animated content'), findsOneWidget);
    });
  });

  group('Layout metrics', () {
    test('token scale is coherent', () {
      expect(GriRadii.sm, 6);
      expect(GriRadii.md, 10);
      expect(GriRadii.lg, 14);
      expect(GriRadii.xl, 16);
      expect(GriRadii.sheet, 20);
      expect(GriRadii.pill, 999);
      expect(GriSpacing.s, 8);
      expect(GriSpacing.l, 16);
      expect(GriShadows.card.length, 1);
      expect(GriShadows.raised.length, 1);
    });
  });
}

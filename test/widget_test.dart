import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('portfolio menu displays owner information and actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Rindu Maharani Nadhirah'), findsOneWidget);
    expect(find.text('2506587131'), findsOneWidget);
    expect(find.text('PBP D'), findsOneWidget);
    expect(find.text('Lihat Proyek'), findsOneWidget);
    expect(find.text('Tambah Proyek'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  const actionNames = ['Lihat Proyek', 'Tambah Proyek', 'Logout'];

  for (final actionName in actionNames) {
    testWidgets('$actionName displays the correct feedback message', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      final action = find.text(actionName);
      await tester.ensureVisible(action);
      await tester.pumpAndSettle();
      await tester.tap(action);
      await tester.pump();

      expect(
        find.text('Kamu telah menekan tombol $actionName!'),
        findsOneWidget,
      );
      expect(find.byType(SnackBar), findsOneWidget);
    });
  }
}

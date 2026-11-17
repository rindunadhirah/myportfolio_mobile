import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

Future<void> _pumpPortfolioApp(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
}

Future<void> _pumpProjectForm(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
}

Future<void> _tapVisibleText(WidgetTester tester, String text) async {
  final target = find.text(text);
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
}

Future<void> _openProjectFormFromCard(WidgetTester tester) async {
  await _tapVisibleText(tester, 'Tambah Proyek');
  await tester.pumpAndSettle();
  expect(find.text('Add Project Form'), findsOneWidget);
}

void main() {
  testWidgets('portfolio menu displays owner information and actions', (
    WidgetTester tester,
  ) async {
    await _pumpPortfolioApp(tester);

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
      await _pumpPortfolioApp(tester);
      await _tapVisibleText(tester, actionName);
      await tester.pump();

      expect(
        find.text('Kamu telah menekan tombol $actionName!'),
        findsOneWidget,
      );
      expect(find.byType(SnackBar), findsOneWidget);
    });
  }

  testWidgets('drawer displays navigation entries', (
    WidgetTester tester,
  ) async {
    await _pumpPortfolioApp(tester);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('My Portfolio'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Add Project'), findsOneWidget);
  });

  testWidgets('drawer opens the project form', (WidgetTester tester) async {
    await _pumpPortfolioApp(tester);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();

    expect(find.text('Add Project Form'), findsOneWidget);
    expect(find.text('Save Project'), findsOneWidget);
  });

  testWidgets('project card opens the form and Back returns home', (
    WidgetTester tester,
  ) async {
    await _pumpPortfolioApp(tester);
    await _openProjectFormFromCard(tester);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Rindu Maharani Nadhirah'), findsOneWidget);
  });

  testWidgets('drawer returns from project form to home', (
    WidgetTester tester,
  ) async {
    await _pumpProjectForm(tester);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Rindu Maharani Nadhirah'), findsOneWidget);
  });

  testWidgets('empty required fields display validation messages', (
    WidgetTester tester,
  ) async {
    await _pumpProjectForm(tester);

    await _tapVisibleText(tester, 'Save Project');
    await tester.pumpAndSettle();

    expect(find.text('Enter a project name.'), findsOneWidget);
    expect(find.text('Enter a project description.'), findsOneWidget);
    expect(find.text('Project added successfully!'), findsNothing);
  });

  testWidgets('invalid project link displays a validation message', (
    WidgetTester tester,
  ) async {
    await _pumpProjectForm(tester);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Portfolio Mobile');
    await tester.enterText(fields.at(1), 'A Flutter portfolio project');
    await tester.enterText(fields.at(3), 'invalid-link');
    await _tapVisibleText(tester, 'Save Project');
    await tester.pumpAndSettle();

    expect(
      find.text('Enter a valid URL starting with http:// or https://.'),
      findsOneWidget,
    );
    expect(find.text('Project added successfully!'), findsNothing);
  });

  testWidgets('valid project data appears in dialog and form resets', (
    WidgetTester tester,
  ) async {
    await _pumpProjectForm(tester);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Portfolio Mobile');
    await tester.enterText(fields.at(1), 'A Flutter portfolio project');
    await tester.enterText(fields.at(2), 'Flutter, Dart');
    await tester.enterText(fields.at(3), 'https://example.com');

    final categoryField = find.byType(DropdownButtonFormField<String>);
    await tester.ensureVisible(categoryField);
    await tester.pumpAndSettle();
    await tester.tap(categoryField);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mobile Development').last);
    await tester.pumpAndSettle();

    await _tapVisibleText(tester, 'Save Project');
    await tester.pumpAndSettle();

    expect(find.text('Project added successfully!'), findsOneWidget);
    expect(find.text('Project Name: Portfolio Mobile'), findsOneWidget);
    expect(
      find.text('Description: A Flutter portfolio project'),
      findsOneWidget,
    );
    expect(find.text('Category: Mobile Development'), findsOneWidget);
    expect(find.text('Technologies: Flutter, Dart'), findsOneWidget);
    expect(find.text('Link: https://example.com'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    final resetFields = tester
        .widgetList<TextFormField>(find.byType(TextFormField))
        .toList();
    for (final field in resetFields) {
      expect(field.controller?.text, isEmpty);
    }
    expect(find.text('Web Development'), findsOneWidget);
  });
}

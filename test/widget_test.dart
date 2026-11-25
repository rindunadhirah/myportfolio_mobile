import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';

import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

ApiClient _buildApiClient({String projectBody = '[]', int statusCode = 200}) {
  return ApiClient(
    baseUrl: 'http://example.test',
    client: MockClient(
      (_) async => http.Response(
        projectBody,
        statusCode,
        headers: {'content-type': 'application/json'},
      ),
    ),
  );
}

Future<void> _pumpPortfolioApp(
  WidgetTester tester, {
  String projectBody = '[]',
}) async {
  await tester.pumpWidget(
    MyApp(apiClient: _buildApiClient(projectBody: projectBody)),
  );
}

Future<void> _pumpProjectForm(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
}

Future<void> _pumpExperienceForm(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: ExperienceFormPage()));
}

Future<void> _tapVisibleText(WidgetTester tester, String text) async {
  final target = find.text(text);
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
}

Future<void> _openProjectFormFromCard(WidgetTester tester) async {
  await _tapVisibleText(tester, 'Add Project');
  await tester.pumpAndSettle();
  expect(find.text('Add a Project'), findsOneWidget);
}

Future<void> _openExperienceFormFromCard(WidgetTester tester) async {
  await _tapVisibleText(tester, 'Add Experience');
  await tester.pumpAndSettle();
  expect(find.text('Add an Experience'), findsOneWidget);
}

Future<void> _chooseInitialDate(WidgetTester tester, Key fieldKey) async {
  await tester.ensureVisible(find.byKey(fieldKey));
  await tester.tap(find.byKey(fieldKey));
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
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
    expect(find.text('View Projects'), findsOneWidget);
    expect(find.text('Add Project'), findsOneWidget);
    expect(find.text('Add Experience'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);
  });

  const actionNames = [
    'View Projects',
    'Add Project',
    'Add Experience',
    'Log Out',
  ];

  for (final actionName in actionNames) {
    testWidgets('$actionName displays the correct feedback message', (
      WidgetTester tester,
    ) async {
      await _pumpPortfolioApp(tester);
      await _tapVisibleText(tester, actionName);
      await tester.pump();

      expect(find.text('$actionName selected.'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });
  }

  testWidgets('drawer displays navigation entries', (
    WidgetTester tester,
  ) async {
    await _pumpPortfolioApp(tester);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('Nadhirah'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'View Projects'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Add Project'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Add Experience'), findsOneWidget);
  });

  testWidgets('drawer opens the project form', (WidgetTester tester) async {
    await _pumpPortfolioApp(tester);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Add Project'));
    await tester.pumpAndSettle();

    expect(find.text('Add a Project'), findsOneWidget);
    expect(find.text('Save Project'), findsOneWidget);
  });

  testWidgets('project list loads API data and opens project details', (
    WidgetTester tester,
  ) async {
    final projectBody = jsonEncode([
      {
        'id': '36bc13fa-2ed6-463d-b770-d9da337e1f64',
        'title': 'SisPro',
        'slug': 'sispro',
        'summary': 'A women safety and smart protection platform.',
        'context': 'SISTECH final project',
        'role': 'Product Manager',
        'contributions': ['Defined product requirements.'],
        'technologies': ['Django', 'Figma'],
        'project_url': 'https://example.com/sispro',
        'image_path': '',
        'started_on': '2026-05-01',
        'ended_on': null,
        'achievement': 'Best Final Project',
        'is_featured': true,
        'created_at': '2026-05-01T00:00:00Z',
        'star_count': 0,
        'is_starred': false,
        'starred_by_names': '',
      },
    ]);
    await _pumpPortfolioApp(tester, projectBody: projectBody);

    await _tapVisibleText(tester, 'View Projects');
    await tester.pumpAndSettle();

    expect(find.text('My Projects'), findsOneWidget);
    expect(find.text('SisPro'), findsOneWidget);
    expect(find.text('Django  •  Figma'), findsOneWidget);

    await tester.tap(find.text('SisPro'));
    await tester.pumpAndSettle();

    expect(find.text('Project Details'), findsOneWidget);
    expect(find.text('Defined product requirements.'), findsOneWidget);
    expect(find.text('Best Final Project'), findsOneWidget);
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

  testWidgets('experience card opens the form and Back returns home', (
    WidgetTester tester,
  ) async {
    await _pumpPortfolioApp(tester);
    await _openExperienceFormFromCard(tester);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Rindu Maharani Nadhirah'), findsOneWidget);
  });

  testWidgets('drawer opens the experience form', (WidgetTester tester) async {
    await _pumpPortfolioApp(tester);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Add Experience'));
    await tester.pumpAndSettle();

    expect(find.text('Add an Experience'), findsOneWidget);
    expect(find.text('Save Experience'), findsOneWidget);
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
    expect(find.text('Enter a project name.'), findsNothing);
    expect(find.text('Enter a project description.'), findsNothing);
  });

  testWidgets('empty experience form displays validation messages', (
    WidgetTester tester,
  ) async {
    await _pumpExperienceForm(tester);

    await _tapVisibleText(tester, 'Save Experience');
    await tester.pumpAndSettle();

    expect(find.text('Enter an experience title.'), findsOneWidget);
    expect(find.text('Enter an organization.'), findsOneWidget);
    expect(find.text('Choose a start date.'), findsOneWidget);
    expect(find.text('Choose an end date.'), findsOneWidget);
    expect(find.text('Enter a description.'), findsOneWidget);
    expect(find.text('Enter a responsibility summary.'), findsOneWidget);
    expect(find.text('Experience added successfully!'), findsNothing);
  });

  testWidgets('experience form rejects input containing only spaces', (
    WidgetTester tester,
  ) async {
    await _pumpExperienceForm(tester);

    await tester.enterText(find.byKey(const Key('experience-title')), '   ');
    await tester.enterText(
      find.byKey(const Key('experience-organization')),
      '   ',
    );
    await tester.pump();

    expect(find.text('Enter an experience title.'), findsOneWidget);
    expect(find.text('Enter an organization.'), findsOneWidget);
  });

  testWidgets('ongoing experience appears in dialog and form resets', (
    WidgetTester tester,
  ) async {
    await _pumpExperienceForm(tester);

    await tester.enterText(
      find.byKey(const Key('experience-title')),
      'Product Management Intern',
    );
    await tester.enterText(
      find.byKey(const Key('experience-organization')),
      'Fasilkom UI',
    );

    await tester.tap(find.byKey(const Key('experience-category')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Internship').last);
    await tester.pumpAndSettle();

    await _chooseInitialDate(tester, const Key('experience-start-date'));
    await tester.ensureVisible(find.byKey(const Key('experience-ongoing')));
    await tester.tap(find.byKey(const Key('experience-ongoing')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('experience-description')),
      'Learned how to develop a useful digital product.',
    );
    await tester.enterText(
      find.byKey(const Key('experience-responsibilities')),
      'Created requirements and worked with a product team.',
    );
    await _tapVisibleText(tester, 'Save Experience');
    await tester.pumpAndSettle();

    expect(find.text('Experience added successfully!'), findsOneWidget);
    expect(find.text('Title: Product Management Intern'), findsOneWidget);
    expect(find.text('Organization: Fasilkom UI'), findsOneWidget);
    expect(find.text('Category: Internship'), findsOneWidget);
    expect(find.text('End Date: Ongoing'), findsOneWidget);
    expect(
      find.text(
        'Description: Learned how to develop a useful digital product.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Responsibilities: Created requirements and worked with a product team.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('experience-title')))
          .controller
          ?.text,
      isEmpty,
    );
    expect(
      tester
          .widget<SwitchListTile>(find.byKey(const Key('experience-ongoing')))
          .value,
      isFalse,
    );
    expect(find.text('Enter an experience title.'), findsNothing);
  });
}

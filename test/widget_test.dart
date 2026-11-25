import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';

import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

ApiClient _buildApiClient({String projectBody = '[]', int statusCode = 200}) {
  return ApiClient(
    baseUrl: 'http://example.test',
    client: MockClient((request) async {
      if (request.url.path == '/api/v1/auth/token/') {
        return http.Response('{"token":"test-token"}', 200);
      }
      if (request.url.path == '/api/v1/auth/logout/') {
        return http.Response('', 204);
      }
      if (request.url.path == '/api/v1/projects/' && request.method == 'POST') {
        final submitted = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(
          jsonEncode({
            ...submitted,
            'id': '36bc13fa-2ed6-463d-b770-d9da337e1f64',
            'slug': 'portfolio-mobile',
            'created_at': '2026-11-25T00:00:00Z',
            'star_count': 0,
            'is_starred': false,
            'starred_by_names': '',
          }),
          201,
        );
      }
      return http.Response(
        projectBody,
        statusCode,
        headers: {'content-type': 'application/json'},
      );
    }),
  );
}

Widget _testApp(Widget home, {bool isLoggedIn = false}) {
  final apiClient = _buildApiClient();
  return MultiProvider(
    providers: [
      Provider<ApiClient>.value(value: apiClient),
      ChangeNotifierProvider(
        create: (_) => AuthState(
          apiClient,
          initialToken: isLoggedIn ? 'test-token' : null,
        ),
      ),
    ],
    child: MaterialApp(home: home),
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
  await tester.pumpWidget(_testApp(const ProjectFormPage(), isLoggedIn: true));
}

Future<void> _pumpExperienceForm(WidgetTester tester) async {
  await tester.pumpWidget(_testApp(const ExperienceFormPage()));
}

Future<void> _tapVisibleText(WidgetTester tester, String text) async {
  final target = find.text(text);
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
}

Future<void> _tapProjectSubmit(WidgetTester tester) async {
  final button = find.byKey(const Key('project-submit'));
  final formScrollable = find.descendant(
    of: find.byType(SingleChildScrollView),
    matching: find.byType(Scrollable),
  );
  await tester.scrollUntilVisible(
    button,
    400,
    scrollable: formScrollable,
  );
  await tester.pumpAndSettle();
  await tester.tap(button);
}

Future<void> _openProjectFormFromCard(WidgetTester tester) async {
  await _tapVisibleText(tester, 'Add Project');
  await tester.pumpAndSettle();
  expect(find.text('Welcome back'), findsOneWidget);
  await tester.enterText(find.byKey(const Key('login-username')), 'owner');
  await tester.enterText(find.byKey(const Key('login-password')), 'password');
  await tester.tap(find.byKey(const Key('login-submit')));
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
    expect(find.text('Log In'), findsOneWidget);
  });

  testWidgets('login action opens the login screen', (
    WidgetTester tester,
  ) async {
    await _pumpPortfolioApp(tester);

    await _tapVisibleText(tester, 'Log In');
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.byKey(const Key('login-username')), findsOneWidget);
    expect(find.byKey(const Key('login-password')), findsOneWidget);
  });

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
    expect(find.widgetWithText(ListTile, 'Log In'), findsOneWidget);
  });

  testWidgets('drawer opens the project form', (WidgetTester tester) async {
    await _pumpPortfolioApp(tester);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Add Project'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('login-username')), 'owner');
    await tester.enterText(find.byKey(const Key('login-password')), 'password');
    await tester.tap(find.byKey(const Key('login-submit')));
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

    await _tapProjectSubmit(tester);
    await tester.pumpAndSettle();

    expect(find.text('Enter a project title.'), findsOneWidget);
    expect(find.text('Enter a project summary.'), findsOneWidget);
    expect(find.text('Enter a project context.'), findsOneWidget);
    expect(find.text('Enter a project role.'), findsOneWidget);
    expect(find.text('Enter a contribution.'), findsOneWidget);
    expect(find.text('Enter a technology.'), findsOneWidget);
    expect(find.text('Enter a project URL.'), findsOneWidget);
    expect(find.text('Enter a start date.'), findsOneWidget);
    expect(find.text('Project added successfully!'), findsNothing);
  });

  testWidgets('invalid project link displays a validation message', (
    WidgetTester tester,
  ) async {
    await _pumpProjectForm(tester);

    await tester.enterText(
      find.byKey(const Key('project-url')),
      'invalid-link',
    );
    await _tapProjectSubmit(tester);
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

    await tester.enterText(
      find.byKey(const Key('project-title')),
      'Portfolio Mobile',
    );
    await tester.enterText(
      find.byKey(const Key('project-summary')),
      'A Flutter portfolio project',
    );
    await tester.enterText(
      find.byKey(const Key('project-context')),
      'Tutorial 10',
    );
    await tester.enterText(find.byKey(const Key('project-role')), 'Developer');
    await tester.enterText(
      find.byKey(const Key('project-contributions')),
      'Connected Flutter to Django.\nAdded token login.',
    );
    await tester.enterText(
      find.byKey(const Key('project-technologies')),
      'Flutter, Dart',
    );
    await tester.enterText(
      find.byKey(const Key('project-url')),
      'https://example.com',
    );
    await _chooseInitialDate(tester, const Key('project-start-date'));
    await tester.enterText(
      find.byKey(const Key('project-achievement')),
      'Completed Tutorial 10',
    );

    await _tapProjectSubmit(tester);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Project added successfully!'), findsOneWidget);
    expect(find.text('Project: Portfolio Mobile'), findsOneWidget);
    expect(find.text('Role: Developer'), findsOneWidget);
    expect(find.text('Technologies: Flutter, Dart'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('project-title')))
          .controller
          ?.text,
      isEmpty,
    );
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('project-start-date')))
          .controller
          ?.text,
      isEmpty,
    );
    expect(find.text('Enter a project title.'), findsNothing);
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

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  group('ApiClient', () {
    test('loads and maps Django project data', () async {
      final client = ApiClient(
        baseUrl: 'http://example.test',
        client: MockClient((request) async {
          expect(request.url.path, '/api/v1/projects/');
          expect(request.headers['Accept'], 'application/json');
          return http.Response(
            jsonEncode([
              {
                'id': '36bc13fa-2ed6-463d-b770-d9da337e1f64',
                'title': 'Portfolio',
                'slug': 'portfolio',
                'summary': 'A personal portfolio.',
                'context': 'PBP assignment',
                'role': 'Developer',
                'contributions': ['Built the mobile interface.'],
                'technologies': ['Flutter', 'Django'],
                'project_url': 'https://example.com',
                'image_path': 'img/projects/portfolio.webp',
                'started_on': '2026-11-01',
                'ended_on': null,
                'achievement': '',
                'is_featured': true,
                'created_at': '2026-11-01T00:00:00Z',
                'star_count': 2,
                'is_starred': false,
                'starred_by_names': 'rindu, visitor',
              },
            ]),
            200,
          );
        }),
      );

      final projects = await client.getProjects();

      expect(projects, hasLength(1));
      expect(projects.single.title, 'Portfolio');
      expect(projects.single.technologies, ['Flutter', 'Django']);
      expect(projects.single.starCount, 2);
      expect(
        client.resolveMediaUrl(projects.single.imagePath),
        'http://example.test/static/img/projects/portfolio.webp',
      );
    });

    test('reports a safe error when the server rejects a request', () async {
      final client = ApiClient(
        baseUrl: 'http://example.test',
        client: MockClient(
          (_) async => http.Response('<html>Error</html>', 500),
        ),
      );

      expect(
        client.getProjects(),
        throwsA(
          isA<ApiException>()
              .having((error) => error.statusCode, 'statusCode', 500)
              .having(
                (error) => error.message,
                'message',
                'The server could not complete the request.',
              ),
        ),
      );
    });

    test('creates a project with its token and JSON body', () async {
      final client = ApiClient(
        baseUrl: 'http://example.test',
        client: MockClient((request) async {
          expect(request.url.path, '/api/v1/projects/');
          expect(request.method, 'POST');
          expect(request.headers['Authorization'], 'Token mobile-token');
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          expect(body['title'], 'Portfolio Mobile');
          expect(body.containsKey('slug'), isFalse);

          return http.Response(
            jsonEncode({
              ...body,
              'id': '36bc13fa-2ed6-463d-b770-d9da337e1f64',
              'slug': 'portfolio-mobile',
              'created_at': '2026-11-25T00:00:00Z',
              'star_count': 0,
              'is_starred': false,
              'starred_by_names': '',
            }),
            201,
          );
        }),
      );
      const project = Project(
        title: 'Portfolio Mobile',
        summary: 'A Flutter portfolio.',
        context: 'Tutorial 10',
        role: 'Developer',
        contributions: ['Connected the API.'],
        technologies: ['Flutter', 'Django'],
        projectUrl: 'https://example.com',
        imagePath: '',
        startedOn: '2026-11-25',
      );

      final created = await client.createProject(
        project,
        token: 'mobile-token',
      );

      expect(created.id, isNotNull);
      expect(created.slug, 'portfolio-mobile');
    });
  });
}

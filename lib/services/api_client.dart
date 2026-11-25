import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/project.dart';

/// Describes a request that the Django API could not complete.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

/// Handles HTTP communication with the Django portfolio API.
class ApiClient {
  ApiClient({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      baseUrl = (baseUrl ?? apiBaseUrl).replaceFirst(RegExp(r'/$'), '');

  final http.Client _client;
  final String baseUrl;

  /// Loads all projects that can be viewed without authentication.
  Future<List<Project>> getProjects() async {
    try {
      final response = await _client.get(
        _uri('/api/v1/projects/'),
        headers: const {'Accept': 'application/json'},
      );
      _ensureSuccess(response);

      final decoded = jsonDecode(response.body);
      if (decoded is! List) {
        throw const FormatException('Expected a project list.');
      }

      return decoded
          .map((item) => Project.fromJson(item as Map<String, dynamic>))
          .toList();
    } on http.ClientException {
      throw const ApiException(
        'The portfolio server could not be reached. Please try again.',
      );
    } on FormatException {
      throw const ApiException(
        'The project data could not be read. Please try again.',
      );
    }
  }

  /// Turns a stored Django static path or full URL into a displayable URL.
  String? resolveMediaUrl(String path) {
    final trimmedPath = path.trim();
    if (trimmedPath.isEmpty) return null;

    final parsed = Uri.tryParse(trimmedPath);
    if (parsed != null && parsed.hasScheme) return trimmedPath;

    var normalizedPath = trimmedPath.replaceFirst(RegExp(r'^/+'), '');
    if (!normalizedPath.startsWith('static/')) {
      normalizedPath = 'static/$normalizedPath';
    }
    return '$baseUrl/$normalizedPath';
  }

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;

    throw ApiException(
      'The server could not complete the request.',
      statusCode: response.statusCode,
    );
  }

  void close() => _client.close();
}

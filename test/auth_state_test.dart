import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

void main() {
  test('login stores a token and logout revokes it', () async {
    var logoutHeader = '';
    final apiClient = ApiClient(
      baseUrl: 'http://example.test',
      client: MockClient((request) async {
        if (request.url.path == '/api/v1/auth/token/') {
          return http.Response('{"token":"mobile-token"}', 200);
        }
        if (request.url.path == '/api/v1/auth/logout/') {
          logoutHeader = request.headers['Authorization'] ?? '';
          return http.Response('', 204);
        }
        return http.Response('', 404);
      }),
    );
    final authState = AuthState(apiClient);

    await authState.login('owner', 'password');

    expect(authState.isLoggedIn, isTrue);
    expect(authState.token, 'mobile-token');

    await authState.logout();

    expect(logoutHeader, 'Token mobile-token');
    expect(authState.isLoggedIn, isFalse);
    expect(authState.token, isNull);
  });

  test('logout clears local state when the server is unavailable', () async {
    final apiClient = ApiClient(
      baseUrl: 'http://example.test',
      client: MockClient((request) async {
        if (request.url.path == '/api/v1/auth/token/') {
          return http.Response('{"token":"mobile-token"}', 200);
        }
        throw http.ClientException('Offline');
      }),
    );
    final authState = AuthState(apiClient);
    await authState.login('owner', 'password');

    await expectLater(authState.logout(), throwsA(isA<ApiException>()));

    expect(authState.isLoggedIn, isFalse);
    expect(authState.token, isNull);
  });
}

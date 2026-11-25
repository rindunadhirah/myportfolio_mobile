/// Base URL of the Django REST Framework backend.
///
/// Android emulators reach the host computer through `10.0.2.2`. Override the
/// value for Flutter Web with:
/// `--dart-define=API_BASE_URL=http://localhost:8000`.
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8000',
);

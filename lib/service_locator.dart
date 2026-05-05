import 'package:get_it/get_it.dart';
import 'package:flutter_application_1/data/index.dart';
import 'package:flutter_application_1/data/fake_api_client.dart';

final getIt = GetIt.instance;

void setupServiceLocator({ApiClient? mockApiClient}) {
  // For testing, allow injection of mock client
  getIt.registerSingleton<ApiClient>(
    mockApiClient ??
        HttpApiClient(baseUrl: 'http://localhost:3000'),
  );

  getIt.registerSingleton<UserRepository>(
    UserRepository(apiClient: getIt<ApiClient>()),
  );
}

/// Reset service locator (useful for tests)
void resetServiceLocator() {
  getIt.reset();
}

/// Setup with fake API client (useful for development/testing)
void setupServiceLocatorWithFake() {
  resetServiceLocator();
  setupServiceLocator(mockApiClient: FakeApiClient());
}

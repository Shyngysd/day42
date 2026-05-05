import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_application_1/main.dart' as app;
import 'package:flutter_application_1/service_locator.dart';
import 'package:flutter_application_1/data/fake_api_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Full User Flow Integration Test', () {
    setUp(() {
      // Setup with fake API client to avoid real network calls
      resetServiceLocator();
      setupServiceLocator(mockApiClient: FakeApiClient());
    });

    testWidgets('Complete flow: login -> view items -> add item -> logout',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // ============ LOGIN SCREEN ============
      expect(find.byType(TextField), findsWidgets);
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);

      // Enter credentials
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );

      // Tap login button
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // ============ HOME SCREEN - VERIFY ITEMS LOADED ============
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byKey(const Key('items_list')), findsOneWidget);

      // Verify initial items are displayed
      expect(find.byKey(const Key('item_item_1')), findsOneWidget);
      expect(find.byKey(const Key('item_item_2')), findsOneWidget);

      // Verify we can see sample items
      expect(find.text('Sample Item 1'), findsOneWidget);
      expect(find.text('Sample Item 2'), findsOneWidget);

      // ============ ADD NEW ITEM ============
      await tester.enterText(
        find.byKey(const Key('title_field')),
        'New Test Item',
      );
      await tester.enterText(
        find.byKey(const Key('description_field')),
        'This is a test item created during integration test',
      );

      // Tap add button
      await tester.tap(find.byKey(const Key('add_button')));
      await tester.pumpAndSettle();

      // Verify success snackbar appears
      expect(find.text('Item added successfully'), findsOneWidget);

      // Verify new item appears in the list
      expect(find.text('New Test Item'), findsOneWidget);
      expect(
        find.text('This is a test item created during integration test'),
        findsOneWidget,
      );

      // ============ VERIFY LOGOUT BUTTON EXISTS ============
      expect(find.byKey(const Key('logout_button')), findsOneWidget);

      // ============ LOGOUT ============
      await tester.tap(find.byKey(const Key('logout_button')));
      await tester.pumpAndSettle();

      // ============ VERIFY BACK TO LOGIN SCREEN ============
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);
    });

    testWidgets('Login fails with invalid credentials',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Enter wrong credentials
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'wrong@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'wrongpassword',
      );

      // Tap login button
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Verify error message is displayed
      expect(find.text('Invalid credentials'), findsOneWidget);

      // Verify we're still on login screen
      expect(find.byKey(const Key('login_button')), findsOneWidget);
    });
  });
}

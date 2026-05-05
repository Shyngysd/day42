import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_application_1/data/index.dart';
import 'package:flutter_application_1/models/index.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  group('UserRepository Tests', () {
    late MockApiClient mockApiClient;
    late UserRepository userRepository;

    setUp(() {
      mockApiClient = MockApiClient();
      userRepository = UserRepository(apiClient: mockApiClient);
    });

    test('login should store user and call apiClient.login', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      final mockUser = User(
        id: '1',
        email: email,
        name: 'Test User',
        token: 'test_token_123',
      );

      when(() => mockApiClient.login(email, password)).thenAnswer(
        (_) async => mockUser,
      );

      // Act
      final result = await userRepository.login(email, password);

      // Assert
      expect(result, equals(mockUser));
      expect(userRepository.currentUser, equals(mockUser));
      verify(() => mockApiClient.login(email, password)).called(1);
    });

    test('login should throw on invalid credentials', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'wrong_password';

      when(() => mockApiClient.login(email, password)).thenThrow(
        Exception('Invalid credentials'),
      );

      // Act & Assert
      expect(
        () => userRepository.login(email, password),
        throwsException,
      );
      verify(() => mockApiClient.login(email, password)).called(1);
    });

    test('getItems should call apiClient.getItems when user is logged in',
        () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      final mockUser = User(
        id: '1',
        email: email,
        name: 'Test User',
        token: 'test_token_123',
      );
      final mockItems = [
        Item(
          id: '1',
          title: 'Item 1',
          description: 'Description 1',
          userId: '1',
          createdAt: DateTime.now(),
        ),
        Item(
          id: '2',
          title: 'Item 2',
          description: 'Description 2',
          userId: '1',
          createdAt: DateTime.now(),
        ),
      ];

      when(() => mockApiClient.login(email, password)).thenAnswer(
        (_) async => mockUser,
      );
      when(() => mockApiClient.getItems()).thenAnswer(
        (_) async => mockItems,
      );

      // Act
      await userRepository.login(email, password);
      final result = await userRepository.getItems();

      // Assert
      expect(result, equals(mockItems));
      expect(result.length, equals(2));
      verify(() => mockApiClient.getItems()).called(1);
    });

    test('getItems should throw when user is not logged in', () async {
      // Arrange & Act & Assert
      expect(
        () => userRepository.getItems(),
        throwsException,
      );
    });

    test('addItem should call apiClient.addItem when user is logged in',
        () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      const title = 'New Item';
      const description = 'New Description';

      final mockUser = User(
        id: '1',
        email: email,
        name: 'Test User',
        token: 'test_token_123',
      );
      final mockNewItem = Item(
        id: '3',
        title: title,
        description: description,
        userId: '1',
        createdAt: DateTime.now(),
      );

      when(() => mockApiClient.login(email, password)).thenAnswer(
        (_) async => mockUser,
      );
      when(
        () => mockApiClient.addItem(title, description),
      ).thenAnswer(
        (_) async => mockNewItem,
      );

      // Act
      await userRepository.login(email, password);
      final result = await userRepository.addItem(title, description);

      // Assert
      expect(result, equals(mockNewItem));
      verify(() => mockApiClient.addItem(title, description)).called(1);
    });

    test('addItem should throw when user is not logged in', () async {
      // Arrange & Act & Assert
      expect(
        () => userRepository.addItem('Title', 'Description'),
        throwsException,
      );
    });

    test('logout should clear user and call apiClient.logout', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      final mockUser = User(
        id: '1',
        email: email,
        name: 'Test User',
        token: 'test_token_123',
      );

      when(() => mockApiClient.login(email, password)).thenAnswer(
        (_) async => mockUser,
      );
      when(() => mockApiClient.logout()).thenAnswer((_) async {});

      // Act
      await userRepository.login(email, password);
      expect(userRepository.currentUser, isNotNull);

      await userRepository.logout();

      // Assert
      expect(userRepository.currentUser, isNull);
      verify(() => mockApiClient.logout()).called(1);
    });

    test('logout should throw when user is not logged in', () async {
      // Arrange & Act & Assert
      expect(
        () => userRepository.logout(),
        throwsException,
      );
    });
  });
}

import 'dart:convert';
import 'package:flutter_application_1/data/api_client.dart';
import 'package:flutter_application_1/models/index.dart';

/// Fake API Client for testing with fixed responses
class FakeApiClient implements ApiClient {
  final Map<String, User> users = {
    'test@example.com': User(
      id: 'user_1',
      email: 'test@example.com',
      name: 'Test User',
      token: 'fake_token_123',
    ),
  };

  final Map<String, List<Item>> userItems = {
    'user_1': [
      Item(
        id: 'item_1',
        title: 'Sample Item 1',
        description: 'This is a sample item',
        userId: 'user_1',
        createdAt: DateTime(2024, 1, 1),
      ),
      Item(
        id: 'item_2',
        title: 'Sample Item 2',
        description: 'This is another sample item',
        userId: 'user_1',
        createdAt: DateTime(2024, 1, 2),
      ),
    ],
  };

  String? _authToken;
  String? _authenticatedUserId;

  @override
  void setAuthToken(String token) {
    _authToken = token;
  }

  @override
  Future<User> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (email == 'test@example.com' && password == 'password123') {
      final user = users['test@example.com']!;
      _authToken = user.token;
      _authenticatedUserId = user.id;
      return user;
    } else {
      throw Exception('Invalid credentials');
    }
  }

  @override
  Future<List<Item>> getItems() async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (_authenticatedUserId == null) {
      throw Exception('Not authenticated');
    }

    return userItems[_authenticatedUserId] ?? [];
  }

  @override
  Future<Item> addItem(String title, String description) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (_authenticatedUserId == null) {
      throw Exception('Not authenticated');
    }

    final newItem = Item(
      id: 'item_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: description,
      userId: _authenticatedUserId!,
      createdAt: DateTime.now(),
    );

    userItems.putIfAbsent(_authenticatedUserId!, () => []).add(newItem);
    return newItem;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (_authenticatedUserId == null) {
      throw Exception('Not authenticated');
    }

    _authToken = null;
    _authenticatedUserId = null;
  }
}

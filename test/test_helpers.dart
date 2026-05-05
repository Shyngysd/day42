import 'package:flutter_application_1/data/index.dart';
import 'package:flutter_application_1/models/index.dart';

/// Test utilities and helpers for creating mock objects

/// Create a test user
User createTestUser({
  String id = 'test_user_1',
  String email = 'test@example.com',
  String name = 'Test User',
  String token = 'test_token_123',
}) {
  return User(
    id: id,
    email: email,
    name: name,
    token: token,
  );
}

/// Create a test item
Item createTestItem({
  String id = 'test_item_1',
  String title = 'Test Item',
  String description = 'Test Description',
  String userId = 'test_user_1',
  DateTime? createdAt,
}) {
  return Item(
    id: id,
    title: title,
    description: description,
    userId: userId,
    createdAt: createdAt ?? DateTime.now(),
  );
}

/// Create multiple test items
List<Item> createTestItems({
  int count = 3,
  String userIdPrefix = 'user_',
  String titlePrefix = 'Item ',
}) {
  return List.generate(
    count,
    (index) => createTestItem(
      id: 'item_$index',
      title: '$titlePrefix${index + 1}',
      description: 'Description for item ${index + 1}',
      userId: '$userIdPrefix${index ~/ 3}',
    ),
  );
}

/// Create a login response (for API mocking)
Map<String, dynamic> createLoginResponse(User user) {
  return {
    'user': user.toJson(),
    'success': true,
  };
}

/// Create a list of items response (for API mocking)
Map<String, dynamic> createItemsResponse(List<Item> items) {
  return {
    'items': items.map((item) => item.toJson()).toList(),
    'count': items.length,
    'success': true,
  };
}

/// Create a single item response (for API mocking)
Map<String, dynamic> createItemResponse(Item item) {
  return {
    'item': item.toJson(),
    'success': true,
  };
}

/// Create an error response (for API mocking)
Map<String, dynamic> createErrorResponse({
  required String message,
  int statusCode = 400,
}) {
  return {
    'error': message,
    'statusCode': statusCode,
    'success': false,
  };
}

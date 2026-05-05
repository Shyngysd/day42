import 'package:flutter_application_1/models/index.dart';

abstract class ApiClient {
  /// Login with email and password
  /// Returns User object with auth token
  Future<User> login(String email, String password);

  /// Get all items for the current user
  Future<List<Item>> getItems();

  /// Add a new item
  Future<Item> addItem(String title, String description);

  /// Logout (invalidate token)
  Future<void> logout();

  /// Set the auth token for subsequent requests
  void setAuthToken(String token);
}

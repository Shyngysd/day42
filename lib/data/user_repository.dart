import 'package:flutter_application_1/data/api_client.dart';
import 'package:flutter_application_1/models/index.dart';

class UserRepository {
  final ApiClient apiClient;
  User? _currentUser;

  UserRepository({required this.apiClient});

  User? get currentUser => _currentUser;

  Future<User> login(String email, String password) async {
    _currentUser = await apiClient.login(email, password);
    return _currentUser!;
  }

  Future<List<Item>> getItems() async {
    if (_currentUser == null) {
      throw Exception('User not logged in');
    }
    return await apiClient.getItems();
  }

  Future<Item> addItem(String title, String description) async {
    if (_currentUser == null) {
      throw Exception('User not logged in');
    }
    return await apiClient.addItem(title, description);
  }

  Future<void> logout() async {
    if (_currentUser == null) {
      throw Exception('User not logged in');
    }
    await apiClient.logout();
    _currentUser = null;
  }
}

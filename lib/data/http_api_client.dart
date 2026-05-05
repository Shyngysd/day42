import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/index.dart';
import 'api_client.dart';
import 'dart:convert';

class HttpApiClient implements ApiClient {
  final String baseUrl;
  final http.Client httpClient;
  String? _authToken;

  HttpApiClient({
    required this.baseUrl,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  @override
  void setAuthToken(String token) {
    _authToken = token;
  }

  @override
  Future<User> login(String email, String password) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final user = User.fromJson(data['user'] as Map<String, dynamic>);
      _authToken = user.token;
      return user;
    } else if (response.statusCode == 401) {
      throw Exception('Invalid credentials');
    } else {
      throw Exception('Login failed with status ${response.statusCode}');
    }
  }

  @override
  Future<List<Item>> getItems() async {
    if (_authToken == null) {
      throw Exception('Not authenticated');
    }

    final response = await httpClient.get(
      Uri.parse('$baseUrl/api/items'),
      headers: {
        'Authorization': 'Bearer $_authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final items = (data['items'] as List<dynamic>)
          .map((item) => Item.fromJson(item as Map<String, dynamic>))
          .toList();
      return items;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to get items with status ${response.statusCode}');
    }
  }

  @override
  Future<Item> addItem(String title, String description) async {
    if (_authToken == null) {
      throw Exception('Not authenticated');
    }

    final response = await httpClient.post(
      Uri.parse('$baseUrl/api/items'),
      headers: {
        'Authorization': 'Bearer $_authToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'description': description,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return Item.fromJson(data['item'] as Map<String, dynamic>);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to add item with status ${response.statusCode}');
    }
  }

  @override
  Future<void> logout() async {
    if (_authToken == null) {
      throw Exception('Not authenticated');
    }

    final response = await httpClient.post(
      Uri.parse('$baseUrl/api/auth/logout'),
      headers: {
        'Authorization': 'Bearer $_authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      _authToken = null;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Logout failed with status ${response.statusCode}');
    }
  }
}

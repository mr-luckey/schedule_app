import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:schedule_app/model/event_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      'http://ec2-13-43-4-220.eu-west-2.compute.amazonaws.com:3031/api/v1';

  static String? _bearerToken;
  static SharedPreferences? _prefs;

  // ---------------------------
  // Initialize SharedPreferences
  // ---------------------------
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _bearerToken = _prefs?.getString('token');
  }

  // ---------------------------
  // Token management
  // ---------------------------
  static String? get bearerToken => _bearerToken;

  static bool get isLoggedIn =>
      _bearerToken != null && _bearerToken!.isNotEmpty;

  static Future<void> setToken(String token) async {
    _bearerToken = token;
    await _prefs?.setString('token', token);
  }

  static Future<void> clearToken() async {
    _bearerToken = null;
    await _prefs?.remove('token');
  }

  // ---------------------------
  // Common headers
  // ---------------------------
  static Future<Map<String, String>> getHeaders({String? token}) async {
    final usedToken = token ?? _bearerToken;
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (usedToken != null && usedToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $usedToken';
    }
    return headers;
  }

  // ... rest of your existing ApiService methods remain the same ...

  // ---------------------------
  // Login API
  // ---------------------------
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/sessions');
    final Map<String, dynamic> requestBody = {
      "session": {"email": email, "password": password},
    };

    final result = await _handleRequest(
      http.post(
        uri,
        headers: await getHeaders(),
        body: jsonEncode(requestBody),
      ),
    );

    if (result['success'] == true) {
      final data = result['data'];
      final token = _extractToken(data);
      if (token != null && token.isNotEmpty) {
        await setToken(token); // Use the new setToken method
      }
    }

    return result;
  }
  // static const String baseUrl =
  //     'http://ec2-13-43-4-220.eu-west-2.compute.amazonaws.com:3031/api/v1';

  // static String? _bearerToken;

  // ---------------------------
  // Common headers
  // ---------------------------
  // static Future<Map<String, String>> getHeaders({String? token}) async {
  //   final usedToken = token ?? _bearerToken;
  //   final headers = <String, String>{'Content-Type': 'application/json'};

  //   if (usedToken != null && usedToken.isNotEmpty) {
  //     headers['Authorization'] = 'Bearer $usedToken';
  //   }
  //   return headers;
  // }

  // ---------------------------
  // Helper request handler
  // ---------------------------
  static Future<Map<String, dynamic>> _handleRequest(
    Future<http.Response> request, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      final response = await request.timeout(timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
          'statusCode': response.statusCode,
        };
      } else {
        return {
          'success': false,
          'error': _parseError(response),
          'statusCode': response.statusCode,
        };
      }
    } on SocketException {
      return {
        'success': false,
        'error': 'No internet connection. Please check your network.',
      };
    } on FormatException {
      return {
        'success': false,
        'error': 'Invalid response from server. Please try again.',
      };
    } on http.ClientException catch (e) {
      return {'success': false, 'error': 'Network error: ${e.message}'};
    } on Exception catch (e) {
      return {
        'success': false,
        'error': 'An unexpected error occurred: ${e.toString()}',
      };
    }
  }

  static String _parseError(http.Response response) {
    try {
      final responseBody = jsonDecode(response.body);
      return responseBody['message'] ??
          responseBody['error'] ??
          'Server returned status ${response.statusCode}';
    } catch (e) {
      return 'Server returned status ${response.statusCode}: ${response.body}';
    }
  }

  // ---------------------------
  // Token helpers
  // ---------------------------
  // static String? get bearerToken => _bearerToken;

  // static void clearToken() {
  //   _bearerToken = null;
  // }

  static String? _extractToken(dynamic data) {
    if (data == null) return null;

    String? tryFromMap(Map map) {
      if (map.containsKey('token') && map['token'] is String) {
        return map['token'] as String;
      }
      if (map.containsKey('access_token') && map['access_token'] is String) {
        return map['access_token'] as String;
      }
      if (map.containsKey('auth_token') && map['auth_token'] is String) {
        return map['auth_token'] as String;
      }
      if (map.containsKey('data') && map['data'] is Map) {
        final inner = tryFromMap(map['data'] as Map);
        if (inner != null) return inner;
      }
      if (map.containsKey('session') && map['session'] is Map) {
        final inner = tryFromMap(map['session'] as Map);
        if (inner != null) return inner;
      }
      if (map.containsKey('user') && map['user'] is Map) {
        final inner = tryFromMap(map['user'] as Map);
        if (inner != null) return inner;
      }
      return null;
    }

    if (data is Map) {
      return tryFromMap(data);
    }

    return null;
  }

  // ---------------------------
  // Get Orders API
  // ---------------------------
  // Update the getOrders method in Api_Service.dart
  static Future<List<Event>> getOrders({String? token}) async {
    try {
      final Uri uri = Uri.parse('$baseUrl/orders');
      print('🔄 Fetching orders from: $uri');

      final response = await _handleRequest(
        http.get(uri, headers: await getHeaders(token: token)),
      );

      print('📦 Raw API Response: ${response.toString()}');

      if (response['success'] == true) {
        final data = response['data'];
        print('📊 Response data type: ${data.runtimeType}');
        print('📊 Response data: $data');

        // Handle different response structures
        if (data is List) {
          print('✅ Processing as List with ${data.length} items');
          final events = data.map((item) {
            print('📝 Processing item: $item');
            return Event.fromJson(item);
          }).toList();
          print('✅ Successfully parsed ${events.length} events');
          return events;
        } else if (data is Map && data.containsKey('orders')) {
          final List<dynamic> orders = data['orders'];
          print('✅ Processing as Map with orders key, ${orders.length} items');
          return orders.map((item) => Event.fromJson(item)).toList();
        } else if (data is Map && data.containsKey('data')) {
          final List<dynamic> orders = data['data'];
          print('✅ Processing as Map with data key, ${orders.length} items');
          return orders.map((item) => Event.fromJson(item)).toList();
        } else {
          print('❌ Unexpected API response format: $data');
          throw Exception('Unexpected API response format: $data');
        }
      } else {
        print('❌ API returned error: ${response['error']}');
        throw Exception('Failed to load orders: ${response['error']}');
      }
    } catch (e) {
      print('❌ Error fetching orders: $e');
      throw Exception('Error fetching orders: $e');
    }
  }

  // ---------------------------
  // Login API
  // ---------------------------
  // static Future<Map<String, dynamic>> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   final Uri uri = Uri.parse('$baseUrl/sessions');
  //   final Map<String, dynamic> requestBody = {
  //     "session": {"email": email, "password": password},
  //   };

  //   final result = await _handleRequest(
  //     http.post(
  //       uri,
  //       headers: await getHeaders(),
  //       body: jsonEncode(requestBody),
  //     ),
  //   );

  //   if (result['success'] == true) {
  //     final data = result['data'];
  //     final token = _extractToken(data);
  //     if (token != null && token.isNotEmpty) {
  //       _bearerToken = token;
  //     }
  //   }

  //   return result;
  // }

  // ---------------------------
  // Get Cities
  // ---------------------------
  static Future<Map<String, dynamic>> getCities({String? token}) async {
    final Uri uri = Uri.parse('$baseUrl/cities');
    return await _handleRequest(
      http.get(uri, headers: await getHeaders(token: token)),
    );
  }

  // ---------------------------
  // Get Events
  // ---------------------------
  static Future<Map<String, dynamic>> getEvents({String? token}) async {
    final Uri uri = Uri.parse('$baseUrl/events');
    return await _handleRequest(
      http.get(uri, headers: await getHeaders(token: token)),
    );
  }

  // ---------------------------
  // Get Packages
  // ---------------------------
  static Future<Map<String, dynamic>> getPackages({String? token}) async {
    final Uri uri = Uri.parse('$baseUrl/packages');
    return await _handleRequest(
      http.get(uri, headers: await getHeaders(token: token)),
    );
  }

  // ---------------------------
  // Create Order
  // ---------------------------
  static Future<Map<String, dynamic>> createOrder({
    required Map<String, dynamic> orderData,
    String? token,
  }) async {
    final Uri uri = Uri.parse('$baseUrl/orders');
    return await _handleRequest(
      http.post(
        uri,
        headers: await getHeaders(token: token),
        body: jsonEncode(orderData),
      ),
    );
  }

  static Map<String, dynamic> formatOrderData({
    required String firstname,
    required String lastname,
    required String email,
    required String phone,
    required String nin,
    required String cityId,
    required String address,
    required String eventId,
    required String noOfGest,
    required String eventDate,
    required String eventTime,
    required String startTime,
    required String endTime,
    required String requirement,
    required List<Map<String, dynamic>> orderPackages,
  }) {
    return {
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
      "phone": phone,
      "nin": nin,
      "city_id": cityId,
      "address": address,
      "event_id": eventId,
      "no_of_gest": noOfGest,
      "event_date": eventDate,
      "event_time": eventTime,
      "start_time": startTime,
      "end_time": endTime,
      "requirement": requirement,
      "order_packages_attributes": orderPackages,
    };
  }

  // ---------------------------
  // Get Menus
  // ---------------------------
  static Future<Map<String, dynamic>> getMenus({String? token}) async {
    final Uri uri = Uri.parse('$baseUrl/menus');
    return await _handleRequest(
      http.get(uri, headers: await getHeaders(token: token)),
    );
  }

  // ---------------------------
  // Get Services (menus filtered by service)
  // ---------------------------
  static Future<Map<String, dynamic>> getServices({String? token}) async {
    final Uri uri = Uri.parse('$baseUrl/menus?is_service=1');
    return await _handleRequest(
      http.get(uri, headers: await getHeaders(token: token)),
    );
  }
}

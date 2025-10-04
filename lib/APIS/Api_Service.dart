import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:schedule_app/model/event_model.dart';
import 'package:schedule_app/pages/Edit/models/model.dart' hide Event;
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

  // ---------------------------
  // Helper request handler with status code handling
  // ---------------------------
  static Future<Map<String, dynamic>> _handleRequest(
    Future<http.Response> request, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      final response = await request.timeout(timeout);

      final int status = response.statusCode;
      final String body = response.body;

      // 2xx success
      if (status == 200 || status == 201) {
        dynamic parsed;
        try {
          parsed = jsonDecode(body);
        } catch (_) {
          parsed = body;
        }
        return {'success': true, 'data': parsed, 'statusCode': status};
      }

      // Non-2xx: parse error info
      final parsedError = _tryParseJson(body);
      final friendlyMessage = _parseErrorMessageFromBody(parsedError, status);

      // Special handling for auth errors
      if (status == 401) {
        // clear token so app can redirect to login
        await clearToken();
      }

      return {
        'success': false,
        'error': friendlyMessage,
        'statusCode': status,
        'errorBody': parsedError,
      };
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

  // Try decode JSON, otherwise return raw body
  static dynamic _tryParseJson(String body) {
    try {
      if (body.trim().isEmpty) return null;
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  // Compose a user-friendly message based on common API structures and status code
  static String _parseErrorMessageFromBody(dynamic parsedBody, int statusCode) {
    // If parsedBody is a Map, try extracting common fields
    if (parsedBody is Map) {
      // common keys
      if (parsedBody.containsKey('message') &&
          parsedBody['message'] is String) {
        return parsedBody['message'] as String;
      }
      if (parsedBody.containsKey('error') && parsedBody['error'] is String) {
        return parsedBody['error'] as String;
      }
      // rails-style validation errors: {"errors": {"field": ["err1", "err2"]}}
      if (parsedBody.containsKey('errors')) {
        final errors = parsedBody['errors'];
        if (errors is Map) {
          final buffer = StringBuffer();
          errors.forEach((k, v) {
            if (v is List) {
              buffer.write('$k: ${v.join(", ")}; ');
            } else {
              buffer.write('$k: $v; ');
            }
          });
          final msg = buffer.toString();
          if (msg.isNotEmpty) return msg;
        } else if (errors is List) {
          return errors.join(', ');
        } else if (errors is String) {
          return errors;
        }
      }
      // fallback to nested message fields
      if (parsedBody.containsKey('data') && parsedBody['data'] is Map) {
        final map = parsedBody['data'] as Map;
        if (map.containsKey('message') && map['message'] is String) {
          return map['message'] as String;
        }
      }
    }

    // status code specific defaults
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check the data you have entered.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Forbidden. You don\'t have permission to access this resource.';
      case 404:
        return 'Not found. The requested resource could not be found.';
      case 422:
        return 'Validation failed. Please check the provided information.';
      case 429:
        return 'Too many requests. Please slow down and try again later.';
      case 500:
      default:
        return 'Server error (${statusCode}). Please try again later.';
    }
  }

  static String _parseError(http.Response response) {
    try {
      final responseBody = jsonDecode(response.body);
      if (responseBody is Map) {
        return responseBody['message'] ??
            responseBody['error'] ??
            responseBody.toString();
      }
      return response.body;
    } catch (e) {
      return 'Server returned status ${response.statusCode}: ${response.body}';
    }
  }

  // ---------------------------
  // Token helpers (kept for compatibility)
  // ---------------------------
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
          return orders.map((item) => Event.fromJson(item)).toList();
        } else if (data is Map && data.containsKey('data')) {
          final List<dynamic> orders = data['data'];
          return orders.map((item) => Event.fromJson(item)).toList();
        } else {
          print('❌ Unexpected API response format: $data');
          throw Exception('Unexpected API response format: $data');
        }
      } else {
        final status = response['statusCode'];
        final error = response['error'] ?? 'Unknown error';
        print('❌ API returned error ($status): $error');

        // Example: if unauthorized, throw a specific exception to let the UI redirect to login
        if (status == 401) {
          throw Exception('Unauthorized. Please login again.');
        }

        throw Exception('Failed to load orders: $error');
      }
    } catch (e) {
      print('❌ Error fetching orders: $e');
      throw Exception('Error fetching orders: $e');
    }
  }

  // Get Order by ID
  static Future<EditOrderModel?> getOrderById(var orderId) async {
    try {
      final Uri uri = Uri.parse('$baseUrl/orders/$orderId');
      print('🔄 Fetching order by ID: $uri');

      final response = await _handleRequest(
        http.get(uri, headers: await getHeaders()),
      );

      if (response['success'] == true) {
        final data = response['data'];
        if (data is Map) {
          final order = EditOrderModel.fromJson(data);
          print('✅ Successfully parsed order: ${order.id}');
          return order;
        } else {
          throw Exception('Unexpected API response format: $data');
        }
      } else {
        final status = response['statusCode'];
        final error = response['error'] ?? 'Unknown error';
        if (status == 404) {
          throw Exception('Order not found.');
        } else if (status == 401) {
          throw Exception('Unauthorized. Please login again.');
        }
        throw Exception('Failed to load order: $error');
      }
    } catch (e) {
      print('❌ Error fetching order by ID: $e');
      throw Exception('Error fetching order: $e');
    }
  }

  // Update Order - PUT API
  static Future<Map<String, dynamic>> updateOrder({
    required int orderId,
    required Map<String, dynamic> EditOrderModel,
  }) async {
    try {
      final Uri uri = Uri.parse('$baseUrl/orders/$orderId');
      print('🔄 Updating order at: $uri');
      print('📦 Update data: ${jsonEncode(EditOrderModel)}');

      final response = await _handleRequest(
        http.put(
          uri,
          headers: await getHeaders(),
          body: jsonEncode(EditOrderModel), //FIXME:
        ),
      );
      print("UPDATED NEW BODY WILL BE HERE ");
      print(jsonEncode(EditOrderModel));

      if (response['success'] == true) {
        return response;
      } else {
        final status = response['statusCode'];
        final error = response['error'] ?? 'Unknown error';
        if (status == 422) {
          throw Exception('Validation error: $error');
        } else if (status == 401) {
          throw Exception('Unauthorized. Please login again.');
        }
        return response;
      }
    } catch (e) {
      print('❌ Error updating order: $e');
      return {'success': false, 'error': 'Error updating order: $e'};
    }
  }

  // Format order data for update according to your example
  static Map<String, dynamic> formatUpdateOrderData({
    required int orderId,
    required String firstname,
    required String lastname,
    required String email,
    required String phone,
    required String nin,
    required int cityId,
    required String address,
    required int eventId,
    required String noOfGust,
    required String eventDate,
    required String eventTime,
    required String startTime,
    required String endTime,
    required String requirement,
    required bool isInquiry,
    required int paymentMethodId,
    required List<Map<dynamic, dynamic>> orderServices,
    required List<Map<dynamic, dynamic>> orderPackages,
  }) {
    return {
      "order": {
        "id": orderId,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "phone": phone,
        "nin": nin,
        "city_id": cityId,
        "address": address,
        "event_id": eventId,
        "no_of_gust": noOfGust,
        "event_date": eventDate,
        "event_time": eventTime,
        "start_time": startTime,
        "end_time": endTime,
        "requirement": requirement,
        "is_inquiry": isInquiry,
        "payment_method_id": paymentMethodId,
        // Use *_attributes for nested updates to align with create format
        "order_services_attributes": orderServices,
        "order_packages_attributes": orderPackages,
      },
    };
  }

  // Helper method to convert DateTime to API date format
  static String formatDateForApi(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Helper method to convert TimeOfDay to API time format
  static String formatTimeOfDayForApi(TimeOfDay time, DateTime eventDate) {
    final hourStr = time.hour.toString().padLeft(2, '0');
    final minuteStr = time.minute.toString().padLeft(2, '0');
    return '${formatDateForApi(eventDate)}T${hourStr}:${minuteStr}:00.000Z';
  }

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
    final response = await _handleRequest(
      http.post(
        uri,
        headers: await getHeaders(token: token),
        body: jsonEncode(orderData),
      ),
    );

    if (response['success'] == true) {
      return response;
    } else {
      final status = response['statusCode'];
      final error = response['error'] ?? 'Unknown error';
      if (status == 422) {
        throw Exception('Validation error: $error');
      } else if (status == 401) {
        throw Exception('Unauthorized. Please login again.');
      }
      throw Exception('Failed to create order: $error');
    }
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

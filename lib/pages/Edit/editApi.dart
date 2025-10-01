// import 'package:http/http.dart' as http;
// import 'package:schedule_app/pages/Edit/model.dart';
// import 'dart:convert';
// import 'dart:io';

// import 'package:shared_preferences/shared_preferences.dart';

// class EditApiService {
//   static const String baseUrl =
//       'http://ec2-13-43-4-220.eu-west-2.compute.amazonaws.com:3031/api/v1';

//   static String? _bearerToken;
//   static SharedPreferences? _prefs;

//   // Initialize SharedPreferences
//   static Future<void> init() async {
//     _prefs = await SharedPreferences.getInstance();
//     _bearerToken = _prefs?.getString('token');
//   }

//   // Token management
//   static String? get bearerToken => _bearerToken;

//   static bool get isLoggedIn =>
//       _bearerToken != null && _bearerToken!.isNotEmpty;

//   static Future<void> setToken(String token) async {
//     _bearerToken = token;
//     await _prefs?.setString('token', token);
//   }

//   // Common headers
//   static Future<Map<String, String>> getHeaders({String? token}) async {
//     final usedToken = token ?? _bearerToken;
//     final headers = <String, String>{'Content-Type': 'application/json'};

//     if (usedToken != null && usedToken.isNotEmpty) {
//       headers['Authorization'] = 'Bearer $usedToken';
//     }
//     return headers;
//   }

//   // Helper request handler
//   static Future<Map<String, dynamic>> _handleRequest(
//     Future<http.Response> request, {
//     Duration timeout = const Duration(seconds: 30),
//   }) async {
//     try {
//       final response = await request.timeout(timeout);

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return {
//           'success': true,
//           'data': jsonDecode(response.body),
//           'statusCode': response.statusCode,
//         };
//       } else {
//         return {
//           'success': false,
//           'error': _parseError(response),
//           'statusCode': response.statusCode,
//         };
//       }
//     } on SocketException {
//       return {
//         'success': false,
//         'error': 'No internet connection. Please check your network.',
//       };
//     } on FormatException {
//       return {
//         'success': false,
//         'error': 'Invalid response from server. Please try again.',
//       };
//     } on http.ClientException catch (e) {
//       return {'success': false, 'error': 'Network error: ${e.message}'};
//     } on Exception catch (e) {
//       return {
//         'success': false,
//         'error': 'An unexpected error occurred: ${e.toString()}',
//       };
//     }
//   }

//   static String _parseError(http.Response response) {
//     try {
//       final responseBody = jsonDecode(response.body);
//       return responseBody['message'] ??
//           responseBody['error'] ??
//           'Server returned status ${response.statusCode}';
//     } catch (e) {
//       return 'Server returned status ${response.statusCode}: ${response.body}';
//     }
//   }

//   static String? _extractToken(dynamic data) {
//     if (data == null) return null;

//     String? tryFromMap(Map map) {
//       if (map.containsKey('token') && map['token'] is String) {
//         return map['token'] as String;
//       }
//       if (map.containsKey('access_token') && map['access_token'] is String) {
//         return map['access_token'] as String;
//       }
//       if (map.containsKey('auth_token') && map['auth_token'] is String) {
//         return map['auth_token'] as String;
//       }
//       if (map.containsKey('data') && map['data'] is Map) {
//         final inner = tryFromMap(map['data'] as Map);
//         if (inner != null) return inner;
//       }
//       if (map.containsKey('session') && map['session'] is Map) {
//         final inner = tryFromMap(map['session'] as Map);
//         if (inner != null) return inner;
//       }
//       if (map.containsKey('user') && map['user'] is Map) {
//         final inner = tryFromMap(map['user'] as Map);
//         if (inner != null) return inner;
//       }
//       return null;
//     }

//     if (data is Map) {
//       return tryFromMap(data);
//     }

//     return null;
//   }

//   // Get Single Order by ID
//   static Future<EditOrderModel?> getOrderById(String orderId) async {
//     try {
//       final Uri uri = Uri.parse('$baseUrl/orders/$orderId');
//       print('🔄 Fetching order by ID: $uri');

//       final response = await _handleRequest(
//         http.get(uri, headers: await getHeaders()),
//       );

//       print('📦 Raw API Response for order $orderId: ${response.toString()}');

//       if (response['success'] == true) {
//         final data = response['data'];
//         print('📊 Response data type: ${data.runtimeType}');
//         print('📊 Response data: $data');

//         if (data is Map) {
//           print('✅ Processing order data as Map');
//           final order = EditOrderModel.fromJson(data);
//           print('✅ Successfully parsed order: ${order.id}');
//           return order;
//         } else {
//           print('❌ Unexpected API response format: $data');
//           throw Exception('Unexpected API response format: $data');
//         }
//       } else {
//         print('❌ API returned error: ${response['error']}');
//         throw Exception('Failed to load order: ${response['error']}');
//       }
//     } catch (e) {
//       print('❌ Error fetching order by ID: $e');
//       throw Exception('Error fetching order: $e');
//     }
//   }

//   // Update Order
//   static Future<Map<String, dynamic>> updateOrder({
//     required int orderId,
//     required Map<String, dynamic> orderData,
//   }) async {
//     try {
//       final Uri uri = Uri.parse('$baseUrl/orders/$orderId');
//       print('🔄 Updating order at: $uri');
//       print('📦 Update data: $orderData');

//       final response = await _handleRequest(
//         http.put(uri, headers: await getHeaders(), body: jsonEncode(orderData)),
//       );

//       return response;
//     } catch (e) {
//       print('❌ Error updating order: $e');
//       return {'success': false, 'error': 'Error updating order: $e'};
//     }
//   }

//   // Format order data for update
//   static Map<String, dynamic> formatUpdateOrderData({
//     required String firstname,
//     required String lastname,
//     required String email,
//     required String phone,
//     required String nin,
//     required String cityId,
//     required String address,
//     required String eventId,
//     required String noOfGest,
//     required String eventDate,
//     required String eventTime,
//     required String startTime,
//     required String endTime,
//     required String requirement,
//     required List<Map<String, dynamic>> orderPackages,
//   }) {
//     return {
//       "firstname": firstname,
//       "lastname": lastname,
//       "email": email,
//       "phone": phone,
//       "nin": nin,
//       "city_id": cityId,
//       "address": address,
//       "event_id": eventId,
//       "no_of_gest": noOfGest,
//       "event_date": eventDate,
//       "event_time": eventTime,
//       "start_time": startTime,
//       "end_time": endTime,
//       "requirement": requirement,
//       "order_packages_attributes": orderPackages,
//     };
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
// import 'package:schedule_app/model/edit_order_model.dart';
import 'package:schedule_app/pages/Edit/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditApiService {
  static const String baseUrl =
      'http://ec2-13-43-4-220.eu-west-2.compute.amazonaws.com:3031/api/v1';

  static String? _bearerToken;
  static SharedPreferences? _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _bearerToken = _prefs?.getString('token');
  }

  // Token management
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

  // Common headers
  static Future<Map<String, String>> getHeaders({String? token}) async {
    final usedToken = token ?? _bearerToken;
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (usedToken != null && usedToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $usedToken';
    }
    return headers;
  }

  // Helper request handler
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

  // Get Single Order by ID
  static Future<EditOrderModel?> getOrderById(String orderId) async {
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
        throw Exception('Failed to load order: ${response['error']}');
      }
    } catch (e) {
      print('❌ Error fetching order by ID: $e');
      throw Exception('Error fetching order: $e');
    }
  }

  // Update Order - PUT API
  static Future<Map<String, dynamic>> updateOrder({
    required String orderId,
    required Map<String, dynamic> orderData,
  }) async {
    try {
      final Uri uri = Uri.parse('$baseUrl/orders/$orderId');
      print('🔄 Updating order at: $uri');
      print('📦 Update data: ${jsonEncode(orderData)}');

      final response = await _handleRequest(
        http.put(uri, headers: await getHeaders(), body: jsonEncode(orderData)),
      );

      return response;
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
    required List<Map<String, dynamic>> orderServices,
    required List<Map<String, dynamic>> orderPackages,
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
        "order_services": orderServices,
        "order_packages": orderPackages,
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
}

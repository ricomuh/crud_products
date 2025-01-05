import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

enum HttpMethod {
  get,
  post,
  put,
  delete,
}

class ApiService {
// api endpoint
  // make a variable to store the api endpoint
  final String apiEndpoint = 'https://pss.leolitgames.com/api';
  // final String apiEndpoint = 'http://127.0.0.1:8000/api';

  // make a function to call api, add parameter if include with token
  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body,
      {bool withToken = false}) async {
    // make a variable to store the headers
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };

    // check if withToken is true
    if (withToken) {
      // get token from local device
      final token = await getToken();
      // add token to headers
      headers['Authorization'] = 'Bearer $token';
    }

    // make a variable to store the response
    final response = await http.post(
      Uri.parse('$apiEndpoint/$path'),
      headers: headers,
      body: jsonEncode(body),
    );

    // check if response status code is 200
    if (response.statusCode == 200) {
      // return response body
      return jsonDecode(response.body);
    } else {
      // return error message
      return {
        'error': 'Failed to call API',
      };
    }
  }

  // get
  Future<Map<String, dynamic>> get(String path,
      {bool withToken = false}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };

    if (withToken) {
      final token = await getToken();
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.get(
      Uri.parse('$apiEndpoint/$path'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {
        'error': 'Failed to call API',
      };
    }
  }

  // put
  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body,
      {bool withToken = false}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };

    if (withToken) {
      final token = await getToken();
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.put(
      Uri.parse('$apiEndpoint/$path'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {
        'error': 'Failed to call API',
      };
    }
  }

  // delete
  Future<Map<String, dynamic>> delete(String path,
      {bool withToken = false}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };

    if (withToken) {
      final token = await getToken();
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.delete(
      Uri.parse('$apiEndpoint/$path'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {
        'error': 'Failed to call API',
      };
    }
  }

  Future<void> storeToken(String token) async {
    // store token to local device
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // get token from local device
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  // remove token from local device
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}

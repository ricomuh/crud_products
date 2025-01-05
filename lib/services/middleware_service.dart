import 'package:flutter/material.dart';
import 'package:crud_products/services/api_service.dart';

class MiddlewareService {
  // final ApiService _apiService;

  // MiddlewareService(this._apiService);

  Future<String?> getToken() async {
    try {
      final token = await ApiService().getToken();
      return token;
    } catch (e) {
      debugPrint('Error fetching token: $e');
      return null;
    }
  }
}

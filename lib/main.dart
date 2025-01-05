import 'package:flutter/material.dart';
import 'package:crud_products/services/api_service.dart';
import 'login_page.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final token = await ApiService().getToken();
    if (token == null) {
      setState(() {
        _isLoading = false;
        _isAuthenticated = false;
      });
      return;
    }

    final response = await ApiService().get('auth/user', withToken: true);
    if (response.containsKey('error')) {
      setState(() {
        _isLoading = false;
        _isAuthenticated = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _isAuthenticated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _isAuthenticated ? HomePage() : LoginPage(),
    );
  }
}

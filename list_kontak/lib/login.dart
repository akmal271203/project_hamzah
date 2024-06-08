import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dashboard.dart'; // Import the DashboardScreen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final String _loginUrl = 'https://dummyjson.com/user/login';

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    final response = await http.post(
      Uri.parse(_loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'username': username,
        'password': password,
        'expiresInMins': 30,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('Login successful: $data');
      // Navigate to DashboardScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      print('Login failed: ${response.reasonPhrase}');
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${response.reasonPhrase}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.lightGreenAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100.0),
              Image.asset(
                'assets/logo.png',
                height: 100.0,
              ),
              SizedBox(height: 50.0),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                        textStyle: TextStyle(fontSize: 16.0),
                      ),
                      child: Text('Login'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  // Handle forgot password logic here
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: const Color.fromARGB(255, 245, 8, 8)),
                ),
              ),
              SizedBox(height: 50.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(color: Color.fromRGBO(211, 12, 12, 1)),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle sign up logic here
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Color.fromARGB(255, 209, 14, 14)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

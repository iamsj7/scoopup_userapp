import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scoopup_userapp/home_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) handleLogin; // Callback to handle login

  LoginScreen({required this.handleLogin});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;
  bool obscureText = true;

  final String baseUrl = 'https://menu.scoopup.app';

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v2/client/auth/gettoken'),
      body: {
        'email': emailController.text,
        'password': passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == true) {
        final String authToken = data['token'];

        // Save the authToken to shared preferences
        await saveAuthTokenToSharedPreferences(authToken);

        final String name = data['name'];
        final String email = data['email'];

        // Call the handleLogin callback with user data
        widget.handleLogin({
          'token': authToken,
          'name': name,
          'email': email,
        });
      } else {
        // Handle login error, e.g., show a snackbar
      }
    }
  }

  Future<void> saveAuthTokenToSharedPreferences(String authToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', authToken);

    if (rememberMe) {
      await prefs.setString('rememberedEmail', emailController.text);
      await prefs.setString('rememberedPassword', passwordController.text);
    }
  }

  @override
  void initState() {
    super.initState();
    loadRememberedAccount();
  }

  void loadRememberedAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final rememberedEmail = prefs.getString('rememberedEmail');
    final rememberedPassword = prefs.getString('rememberedPassword');

    if (rememberedEmail != null && rememberedPassword != null) {
      setState(() {
        emailController.text = rememberedEmail;
        passwordController.text = rememberedPassword;
        rememberMe = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    // Toggle password visibility
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                ),
              ),
              obscureText: obscureText,
            ),
            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value!;
                    });
                  },
                ),
                Text('Remember Me'),
              ],
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

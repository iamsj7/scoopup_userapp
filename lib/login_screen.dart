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
  var size, height, width;
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
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    bool isFocused = false;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: ListView(children: [
          Container(
            height: height / 3.5,
            width: width,
            child: Image.asset(
              'images/log.png',
              fit: BoxFit.cover,
            ),
          ),
          // Container(
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.bottomCenter,
          //     end: Alignment.topCenter,
          //     colors: [Color(0xFFFFB6C1), Color.fromARGB(255, 226, 218, 218)],
          //   ),
          // ),
          // child: Padding(
          //   padding: const EdgeInsets.only(top: 150),
          Container(
            width: 428,
            height: height / 1.4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(70),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(15, 0), // changes position of shadow
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Text(
                      'Welcome Back',
                      style: TextStyle(
                        color: Color(0xFFCE4141),
                        fontSize: 24,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        height: 0.03,
                        letterSpacing: -0.02,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Container(
                      width: 360,
                      // height: 60,
                      decoration: ShapeDecoration(
                        color: Color(0x3FD9D9D9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(61, 72, 72, 72)),
                                borderRadius: BorderRadius.circular(20)),
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.black26),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 20,
                  ),
                  Container(
                    width: 360,
                    // height: 60,
                    decoration: ShapeDecoration(
                      color: Color(0x3FD9D9D9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(61, 72, 72, 72)),
                            borderRadius: BorderRadius.circular(20)),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.black26),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            color: Colors.black,
                            obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          activeColor: Colors.black,
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
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 280),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0)),
                      height: 50,
                      width: 250,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(28),
                                    bottomLeft: Radius.circular(28))),
                            primary: Color(0xFFCE4141) // Background color
                            ),
                        onPressed: _login,
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]));
  }
}

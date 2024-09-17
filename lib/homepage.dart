import 'dart:convert';
import 'package:dealsdray/mainpage.dart';
import 'package:dealsdray/register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dealsdray/verification.dart'; // Import the verification page

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String _deviceId = "62b341aeb0ab5ebe28a758a3"; // Example deviceId
  bool isEmailLogin = false; // Toggle between OTP and Email login

  // Function to send OTP
  Future<void> _sendOtp() async {
    final phoneNumber = _phoneController.text;

    if (phoneNumber.isNotEmpty) {
      final url = 'http://devapiv4.dealsdray.com/api/v2/user/otp';
      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "mobileNumber": phoneNumber,
            "deviceId": _deviceId,
          }),
        );

        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          final userId = jsonResponse['userId'] ?? 'defaultUserId'; // Replace with actual userId

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('OTP sent to $phoneNumber')),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Verification(
                phoneNumber: phoneNumber,
                deviceId: _deviceId,
                userId: userId, // Pass userId to the verification page
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send OTP. Please try again.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid phone number')),
      );
    }
  }

  // Function for email login
  // Function for email login
  Future<void> _emailLogin() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      final url = 'http://devapiv4.dealsdray.com/api/v2/user/login'; // Replace with actual login API

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": email,
            "password": password,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login successful')),
          );

          // Redirect to mainpage after login success
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(), // Replace with your mainpage widget
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to login. Please try again.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email and password')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Added SingleChildScrollView
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/delasdray.png",
                  height: 300,
                  width: 300,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Glad To See You",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text("Please provide your phone number or login via email"),
              const SizedBox(height: 20),

              // Switch between OTP and Email Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("OTP Login"),
                  Switch(
                    value: isEmailLogin,
                    onChanged: (value) {
                      setState(() {
                        isEmailLogin = value;
                      });
                    },
                  ),
                  const Text("Email Login"),
                ],
              ),

              // OTP Login Form
              if (!isEmailLogin)
                Column(
                  children: [
                    Container(
                     // width: 300,
                      child: TextField(
                        controller: _phoneController,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          labelText: "Phone",
                          hintText: "Enter valid phone number",
                          prefixIcon: Icon(
                            Icons.phone,

                            size: 20,
                          ),
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _sendOtp,
                      child: const Text('Send OTP'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),

              // Email Login Form
              if (isEmailLogin)
                Column(
                  children: [
                    Container(
                      width: 300,
                      child: TextField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your email",
                          prefixIcon: Icon(
                            Icons.email,
                            color: Color(0xFF009999),
                            size: 27,
                          ),
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 300,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your password",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xFF009999),
                            size: 27,
                          ),
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _emailLogin,
                      child: const Text('Login'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: const Text('Sign Up'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

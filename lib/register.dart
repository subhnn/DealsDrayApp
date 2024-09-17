import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _referralCodeController = TextEditingController();

  // Function to register the user
  Future<void> _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final referralCode = _referralCodeController.text;

    if (email.isNotEmpty && password.isNotEmpty && referralCode.isNotEmpty) {
      final url = 'http://devapiv4.dealsdray.com/api/v2/user/email/referral';

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": email,
            "password": password,
            "referralCode": referralCode,
            "userId": "62a833766ec5dafd6780fc85", // Replace with actual userId if needed
          }),
        );

        if (response.statusCode == 200) {
          // Handle successful registration
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful')),
          );
          Navigator.pop(context); // Navigate back to the previous page
        } else {
          // Decode the response and extract the error message
          final responseBody = jsonDecode(response.body);
          final errorMessage = responseBody['data']['message'] ?? 'Unknown error';

          // Show the error message in the UI
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to register: $errorMessage')),
          );
        }
      } catch (e) {
        // Handle network or other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "Enter your email",
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: "Password",
                hintText: "Enter your password",
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _referralCodeController,
              decoration: const InputDecoration(
                labelText: "Referral Code",
                hintText: "Enter referral code",
                prefixIcon: Icon(Icons.code),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: _register,
                child: const Text("Register"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

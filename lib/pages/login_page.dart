import 'package:flutter/material.dart';
import 'package:mobile_labs/elements/widget/custom_button.dart';
import 'package:mobile_labs/service/auth_service.dart';
import 'package:mobile_labs/service/storage_service.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  LogInPageState createState() => LogInPageState();
}

class LogInPageState extends State<LogInPage> {
  final IAuthService authService = AuthService(SecureStorageService());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _logIn() {
    authService.logIn(
      context,
      usernameController.text,
      passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/elements/photos/background_small.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTextField(usernameController, 'Username'),
                const SizedBox(height: 16),
                _buildTextField(passwordController, 'Password',
                    obscureText: true,),
                const SizedBox(height: 20),
                CustomButton(text: 'Log In', onTap: _logIn),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false,}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}

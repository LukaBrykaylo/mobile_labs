import 'package:flutter/material.dart';
import 'package:mobile_labs/elements/widget/custom_button.dart';
import 'package:mobile_labs/service/auth_service.dart';
import 'package:mobile_labs/service/signup_validation_service.dart';
import 'package:mobile_labs/service/storage_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final IAuthService authService = AuthService(SecureStorageService());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isEmailValid = true;
  bool isNameValid = true;
  bool isPasswordValid = true;

  final SignUpValidationService validationService = SignUpValidationService();

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
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: const TextStyle(color: Colors.white),
                    errorText: isNameValid ? null : 'Invalid name format',
                  ),
                  onChanged: (value) {
                    setState(() {
                      isNameValid = validationService.validationName(value);
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.white),
                    errorText: isEmailValid ? null : 'Invalid email format',
                  ),
                  onChanged: (value) {
                    setState(() {
                      isEmailValid = validationService.validateEmail(value);
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white),
                    errorText:
                        isPasswordValid ? null : 'Invalid password format',
                  ),
                  onChanged: (value) {
                    setState(() {
                      isPasswordValid =
                          validationService.validationPassword(value);
                    });
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Sign Up',
                  onTap: () {
                    if (validationService.validateEmail(emailController.text)) {
                      authService.signUp(
                        context,
                        nameController.text,
                        emailController.text,
                        passwordController.text,
                      );
                    } else {
                      setState(() {
                        isEmailValid = false;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

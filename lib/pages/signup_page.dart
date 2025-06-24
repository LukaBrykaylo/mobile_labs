import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubit/auth/auth_cubit.dart';
import 'package:mobile_labs/elements/widget/custom_button.dart';
import 'package:mobile_labs/service/signup_validation_service.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final SignUpValidationService validationService = SignUpValidationService();

  final ValueNotifier<bool> isNameValid = ValueNotifier(true);
  final ValueNotifier<bool> isEmailValid = ValueNotifier(true);
  final ValueNotifier<bool> isPasswordValid = ValueNotifier(true);

  void _signUp(BuildContext context) {
    final isName = validationService.validationName(nameController.text);
    final isEmail = validationService.validateEmail(emailController.text);
    final isPassword =
        validationService.validationPassword(passwordController.text);

    isNameValid.value = isName;
    isEmailValid.value = isEmail;
    isPasswordValid.value = isPassword;

    if (isName && isEmail && isPassword) {
      context.read<AuthCubit>().signUp(
            nameController.text,
            emailController.text,
            passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, '/tabs');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red,),
            );
          }
        },
        builder: (context, state) {
          return Stack(
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
                    ValueListenableBuilder(
                      valueListenable: isNameValid,
                      builder: (_, bool isValid, __) => TextField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: const TextStyle(color: Colors.white),
                          errorText: isValid ? null : 'Invalid name format',
                        ),
                        onChanged: (value) => isNameValid.value =
                            validationService.validationName(value),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder(
                      valueListenable: isEmailValid,
                      builder: (_, bool isValid, __) => TextField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.white),
                          errorText: isValid ? null : 'Invalid email format',
                        ),
                        onChanged: (value) => isEmailValid.value =
                            validationService.validateEmail(value),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder(
                      valueListenable: isPasswordValid,
                      builder: (_, bool isValid, __) => TextField(
                        controller: passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          errorText: isValid ? null : 'Invalid password format',
                        ),
                        onChanged: (value) => isPasswordValid.value =
                            validationService.validationPassword(value),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (state is AuthLoading)
                      const CircularProgressIndicator(color: Colors.white)
                    else
                      CustomButton(
                        text: 'Sign Up',
                        onTap: () => _signUp(context),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

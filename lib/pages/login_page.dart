import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubit/auth/auth_cubit.dart';
import 'package:mobile_labs/elements/widget/custom_button.dart';

class LogInPage extends StatelessWidget {
  LogInPage({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                    _buildTextField(usernameController, 'Username'),
                    const SizedBox(height: 16),
                    _buildTextField(passwordController, 'Password',
                        obscureText: true,),
                    const SizedBox(height: 20),
                    if (state is AuthLoading)
                      const CircularProgressIndicator(color: Colors.white)
                    else
                      CustomButton(
                        text: 'Log In',
                        onTap: () {
                          context.read<AuthCubit>().logIn(
                                usernameController.text,
                                passwordController.text,
                              );
                        },
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

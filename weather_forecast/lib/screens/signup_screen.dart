import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Để sử dụng Provider
import 'package:weather_forecast/providers/auth_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<AuthProvider>(
        builder: (ctx, auth, _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await auth.signUp(
                        _emailController.text,
                        _passwordController.text,
                      );
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacementNamed(context, '/home');
                      });
                    } catch (e) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Error'),
                            content: Text('Failed to sign up: ${e.toString()}'),
                            actions: [
                              TextButton(
                                onPressed: () {},
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      });
                    }
                  },
                  child: const Text('Sign Up'),
                ),
                TextButton(
                  onPressed: () {
                    // Điều hướng đến trang đăng nhập nếu người dùng đã có tài khoản
                    Navigator.pushNamed(
                        context, '/login'); // Điều hướng đến trang đăng nhập
                  },
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

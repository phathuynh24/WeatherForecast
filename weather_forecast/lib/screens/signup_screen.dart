import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/providers/auth_provider.dart';
import 'package:weather_forecast/utils/constants.dart';
import 'package:weather_forecast/utils/snackbar_helper.dart';
import 'package:weather_forecast/utils/theme.dart';
import 'package:weather_forecast/widgets/or_divider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      body: Center(
        child: Consumer<AuthProvider>(
          builder: (ctx, auth, _) {
            return Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    child: Center(
                      child: SizedBox(
                        width: 400,
                        child: Card(
                          color: Colors.white,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Image.network(
                                  'https://png.pngtree.com/png-clipart/20240320/original/pngtree-sunny-cloudy-weather-illustration-in-3d-style-png-image_14637503.png',
                                  height: 240,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Sign Up',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      // Email TextFormField
                                      TextFormField(
                                        controller: _emailController,
                                        decoration: const InputDecoration(
                                          labelText: 'Email',
                                          prefixIcon: Icon(Icons.email),
                                          border: OutlineInputBorder(),
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your email';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),

                                      // Password TextFormField
                                      TextFormField(
                                        controller: _passwordController,
                                        obscureText: _obscureText,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          prefixIcon: const Icon(Icons.lock),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscureText
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                          ),
                                          border: const OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your password';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),

                                      // Confirm Password TextFormField
                                      TextFormField(
                                        controller: _confirmPasswordController,
                                        obscureText: _obscureText,
                                        decoration: InputDecoration(
                                          labelText: 'Confirm Password',
                                          prefixIcon: const Icon(Icons.lock),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscureText
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                          ),
                                          border: const OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please confirm your password';
                                          }
                                          if (value !=
                                              _passwordController.text) {
                                            return 'Passwords do not match';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      try {
                                        await auth.signUp(
                                          _emailController.text,
                                          _passwordController.text,
                                        );

                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          showCustomSnackbar(
                                              context, 'Sign up successful!',
                                              isSuccess: true);
                                          context.go('/login');
                                        });
                                      } catch (e) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          String message =
                                              'Failed to sign up: ${e.toString()}';
                                          showCustomSnackbar(context, message,
                                              isSuccess: false);
                                        });
                                      }
                                    }
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 30),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            AppBorderRadius
                                                .buttonBorderRadius)),
                                    backgroundColor: AppColors.darkBlue,
                                  ),
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                const OrDivider(),
                                TextButton(
                                  onPressed: () {
                                    context.go('/login');
                                  },
                                  child: const Text(
                                      'Already have an account? Login',
                                      style: TextStyle(
                                        color: AppColors.darkBlue,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (_isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

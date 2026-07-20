import 'package:flutter/material.dart';
import 'package:stem_calc/bottom_nav.dart';
import 'package:stem_calc/login_screen.dart';
import 'package:stem_calc/welcome_screen.dart';
import 'api.dart';
import 'user_session.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _api = ApiService();

  bool _obscurePassword = true;
  bool _agreeTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),

      // App bar
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
          },
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              const Text(
                'Welcome to Stem!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Courier',
                ),
              ),

              const SizedBox(height: 30),

              // Email
              const Text(
                'Email',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontFamily: 'Courier',
                ),
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailController,
                hint: 'Email',
                obscure: false,
              ),

              const SizedBox(height: 18),

              // Username
              const Text(
                'Username',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontFamily: 'Courier',
                ),
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _usernameController,
                hint: 'Username',
                obscure: false,
              ),

              const SizedBox(height: 18),

              // Password
              const Text(
                'Password',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontFamily: 'Courier',
                ),
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _passwordController,
                hint: 'Password',
                obscure: _obscurePassword,
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white38,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _agreeTerms,
                      onChanged: (value) {
                        setState(() => _agreeTerms = value ?? false);
                      },
                      activeColor: Colors.white,
                      checkColor: Colors.black,
                      side: const BorderSide(color: Colors.white54),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                            height: 1.4,
                            fontFamily: 'Courier',
                          ),
                          children: [
                            TextSpan(text: 'I have read and agreed to the STEM '),
                            TextSpan(
                              text: 'User Agreement',
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy policy',
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Create
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _agreeTerms
                      ? () async {
                          if (_emailController.text.trim().isEmpty ||
                              _passwordController.text.trim().isEmpty ||
                              _usernameController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please fill in all fields")),
                            );
                            return;
                          }

                          bool success = await _api.register(
                            _emailController.text.trim(),
                            _usernameController.text.trim(),
                            _passwordController.text.trim(),
                          );

                          if (success) {
                            String textName = _usernameController.text.trim();

                            UserSession.username = textName; 

                            if (!mounted) return;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => WelcomeScreen(username: textName)),
                            );
                          }

                          if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => WelcomeScreen(
                                    username: _usernameController.text.trim(),
                                  ),
                                ),
                              );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Email already exists")),
                            );
                          }
                        }: null,
                      child: const Text(
                        'Create account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Courier',
                          letterSpacing: 1.2,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Bottom navbar
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }

  // Text field
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white, fontFamily: 'Courier'),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(color: Colors.white38, fontFamily: 'Courier'),
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
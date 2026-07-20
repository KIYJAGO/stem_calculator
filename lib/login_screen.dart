import 'package:flutter/material.dart';
import 'package:stem_calc/welcome_screen.dart';
import 'signup_screen.dart';
import 'bottom_nav.dart';
import 'home_screen.dart';
import 'api.dart';
import 'user_session.dart';
import 'admin_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ApiService _api = ApiService();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
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
              MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
          child: TextButton(
            onPressed: () {
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SignUpScreen()),
          );
            },
            child: const Text(
              'Sign up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Courier',
              ),
            ),
          ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            const Text(
              'Welcome back!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'Courier',
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Email / Username',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontFamily: 'Courier',
              ),
            ),

            const SizedBox(height: 10),

            _buildTextField(
              controller: _emailController,
              hint: 'Email / Username',
              obscure: false,
            ),

            const SizedBox(height: 14),

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

            const SizedBox(height: 28),

            // Login button
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
              onPressed: () async {
                final result = await _api.login(
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                );

                if (!mounted) return;

                if (result["success"] == true) {
                  UserSession.userId   = result["user_id"].toString();
                  UserSession.username = result["username"];
                  UserSession.role     = result["role"];

                String role = result["role"]?.toString() ?? "user";
                String username = result["username"]?.toString() ?? "User";

                // Admin
                if (role == 'admin') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminScreen()),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WelcomeScreen(
                        username: username,
                      ),
                    ),
                  );
                }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Email or password incorrect")),
                  );
                }
              },
                child: const Text(
                  'Login',
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
        hintStyle: const TextStyle(color: Colors.white38, fontFamily: 'Courier'),
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _agreeTerms = false;

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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 40),
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
                  _obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.white38,
                  size: 20,
                ),
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              ),
            ),

            const SizedBox(height: 18),

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
                
                // Space between checkbox and text
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
            const SizedBox(height: 20),

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
                    ? () {
                        // TODO: signup logic
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => const HomeScreen()),
                          (route) => false,
                        );
                      }
                    : null, // disable if not checked
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

      // Bottom navbar
      bottomNavigationBar: Container(
        height: 64,
        decoration: const BoxDecoration(
          color: Color(0xFFD9D9D9),
          border: Border(top: BorderSide(color: Color(0xFF2A2A2A))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.headset_outlined, color: Colors.black87, size: 32),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.black87, size: 48),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.black87, size: 32),
              onPressed: () {},
            ),
          ],
        ),
      ),
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
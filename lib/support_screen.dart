import 'package:flutter/material.dart';
import 'bottom_nav.dart';
import 'home_screen.dart';
import 'user_session.dart';
import 'admin_screen.dart';
import 'login_screen.dart';
import 'welcome_screen.dart';
import 'settings_screen.dart';
import 'faq_account_security.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  void _handleBackNavigation(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Widget destination;

      switch (UserSession.lastTabIndex) {
        case 1:
          if (UserSession.isAdmin) {
            destination = const AdminScreen();
          } else if (UserSession.isLoggedIn) {
            destination = WelcomeScreen(username: UserSession.username ?? 'User');
          } else {
            destination = const LoginScreen();
          }
          break;
        case 2:
          destination = const SettingsScreen();
          break;
        default:
          destination = const HomeScreen();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => destination),
      );
    }
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
          onPressed: () => _handleBackNavigation(context),
        ),
        title: const Text(
          'STEM Support',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Courier',
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Top questions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Courier',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildQuestionButton('Formula to count State Debt'),
            const SizedBox(height: 10),
            _buildQuestionButton('How to count 19 Million Job Vacancy'),
            const SizedBox(height: 10),
            _buildQuestionButton('Count President Foreign Visits since office'),

            const SizedBox(height: 30),

            const Text(
              'FAQ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Courier',
              ),
            ),

            const SizedBox(height: 10),

            _buildFAQItem(context, 'Account & Security'),
            _divider(),
            _buildFAQItem(context, 'How to use calculator'),
            _divider(),
            _buildFAQItem(context, "How to find formula that doesn't exist"),
          ],
        ),
      ),

      // Bottom navbar
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }

  // Top question
  Widget _buildQuestionButton(String text) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          debugPrint(text);
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white38),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontFamily: 'Courier',
            ),
          ),
        ),
      ),
    );
  }

  // FAQ
Widget _buildFAQItem(BuildContext context, String text) {
  return InkWell(
    onTap: () {
      switch (text) {
        case 'Account & Security':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const FAQAccountSecurity(),
            ),
          );
          break;

        case 'How to use calculator':
          // TODO: Navigate to calculator FAQ page
          break;

        case "How to find formula that doesn't exist":
          // TODO: Navigate to formula FAQ page
          break;

        default:
          break;
      }
    },
    child: SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontFamily: 'Courier',
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Colors.white54,
            size: 18,
          ),
        ],
      ),
    ),
  );
}

  // Divider
  Widget _divider() {
    return Container(
      height: 1,
      color: Colors.white24,
    );
  }
}
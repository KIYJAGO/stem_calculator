import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stem_calc/bottom_nav.dart';
import 'home_screen.dart';
import 'lang_service.dart';
import 'lang_notifier.dart';
import 'user_session.dart';
import 'support_screen.dart';
import 'login_screen.dart';
import 'welcome_screen.dart';
import 'admin_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  void _showLanguagePicker() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Select Language',
          style: TextStyle(color: Colors.white, fontFamily: 'Courier'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _langOption('English', 'en'),
            _langOption('Indonesia', 'id'),
          ],
        ),
      ),
    );
  }

  Widget _langOption(String label, String code) {
    final isSelected = LangNotifier.instance.currentLang == code;
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontFamily: 'Courier',
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: Colors.white)
          : null,
      onTap: () async {
        await LangNotifier.instance.setLanguage(code);
        if (!context.mounted) return;
        setState(() {});
        Navigator.pop(context);
      },
    );
  }

  void _handleBackNavigation() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Widget destination;

      switch (UserSession.lastTabIndex) {
        case 0:
          destination = const SupportScreen();
          break;
        case 1:
          if (UserSession.isAdmin) {
            destination = const AdminScreen();
          } else if (UserSession.isLoggedIn) {
            destination = WelcomeScreen(username: UserSession.username ?? 'User');
          } else {
            destination = const LoginScreen();
          }
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
    context.watch<LangNotifier>();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _handleBackNavigation,
        ),
        title: Text(
          LangService.get('preferences'),
          style: const TextStyle(
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
          children: [
            _buildItem(
              title: LangService.get('language'),
              value: LangNotifier.instance.currentLang == 'en'
                  ? 'English'
                  : 'Indonesia',
              onTap: () => _showLanguagePicker(),
            ),
            _divider(),
            _buildItem(
              title: LangService.get('theme'),
              value: LangService.get('dark'),
              onTap: () {},
            ),
            _divider(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }

  Widget _buildItem({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white, fontSize: 14, fontFamily: 'Courier',
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white70, fontSize: 13, fontFamily: 'Courier',
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white54, size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(height: 1, color: Colors.white24);
  }
}
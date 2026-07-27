import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'settings_screen.dart';
import 'support_screen.dart';
import 'home_screen.dart';
import 'user_session.dart'; 
import 'welcome_screen.dart';
import 'admin_screen.dart';

class BottomNav extends StatefulWidget {
  final int currentIndex;

  const BottomNav({super.key, required this.currentIndex});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with TickerProviderStateMixin {
  late AnimationController _accountController;
  late AnimationController _settingsController;
  late AnimationController _supportController;

  late Animation<double> _accountScale;
  late Animation<double> _settingsScale;
  late Animation<double> _supportScale;

  @override
  void initState() {
    super.initState();

    _accountController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _settingsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _supportController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _accountScale = Tween(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _accountController, curve: Curves.easeOutBack),
    );

    _settingsScale = Tween(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _settingsController, curve: Curves.easeOutBack),
    );

    _supportScale = Tween(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _supportController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _accountController.dispose();
    _settingsController.dispose();
    _supportController.dispose();
    super.dispose();
  }

  Future<void> _navigate(int index) async {
    if (widget.currentIndex == index) return;

    UserSession.lastTabIndex = widget.currentIndex;

    AnimationController controller;
    Widget page;

    switch (index) {
      case 0:
        controller = _supportController;
        page = const SupportScreen();
        break;
      case 1:
        controller = _accountController;

        if (UserSession.isAdmin) {
          page = const AdminScreen();
        } else if (UserSession.isLoggedIn) {
          page = WelcomeScreen(username: UserSession.username ?? 'User');
        } else {
          page = const LoginScreen();
        }
        break;
      case 2:
        controller = _settingsController;
        page = const SettingsScreen();
        break;
      default:
        controller = _accountController;
        page = const HomeScreen();
    }

    await controller.forward();
    controller.reverse();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Color(0xFFD9D9D9),
        border: Border(top: BorderSide(color: Color(0xFF2A2A2A), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Support Tab
          Transform.scale(
            scale: widget.currentIndex == 0 ? 1.2 : 1.0,
            child: ScaleTransition(
              scale: _supportScale,
              child: IconButton(
                icon: Icon(
                  Icons.headset_mic_outlined,
                  color: widget.currentIndex == 0 ? Colors.black : Colors.black54,
                  size: 30,
                ),
                tooltip: 'Support',
                onPressed: () => _navigate(0),
              ),
            ),
          ),

          // Account / Admin Tab
          Transform.scale(
            scale: widget.currentIndex == 1 ? 1.2 : 1.0,
            child: ScaleTransition(
              scale: _accountScale,
              child: IconButton(
                icon: Icon(
                  Icons.account_circle,
                  color: widget.currentIndex == 1 ? Colors.black : Colors.black54,
                  size: 34,
                ),
                tooltip: UserSession.isAdmin ? 'Admin Dashboard' : 'Profile',
                onPressed: () => _navigate(1),
              ),
            ),
          ),

          // Settings Tab
          Transform.scale(
            scale: widget.currentIndex == 2 ? 1.2 : 1.0,
            child: ScaleTransition(
              scale: _settingsScale,
              child: IconButton(
                icon: Icon(
                  Icons.settings_outlined,
                  color: widget.currentIndex == 2 ? Colors.black : Colors.black54,
                  size: 30,
                ),
                tooltip: 'Settings',
                onPressed: () => _navigate(2),
              ),
            ),
          ),

          // Admin Logout Button
          if (UserSession.isAdmin)
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 28),
              tooltip: 'Logout Admin',
              onPressed: () {
                UserSession.clear();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
        ],
      ),
    );
  }
}
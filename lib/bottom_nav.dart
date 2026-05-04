import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'settings_screen.dart';
import 'support_screen.dart';
import 'home_screen.dart';

class BottomNav extends StatefulWidget {
  final int currentIndex;

  const BottomNav({super.key, required this.currentIndex});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav>
    with TickerProviderStateMixin {

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
      duration: const Duration(milliseconds: 600),
    );

    _settingsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _supportController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _accountScale = Tween(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _accountController, curve: Curves.elasticOut),
    );

    _settingsScale = Tween(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _settingsController, curve: Curves.elasticOut),
    );

    _supportScale = Tween(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _supportController, curve: Curves.elasticOut),
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

    AnimationController controller;

    Widget page;

    switch (index) {
      case 0:
        controller = _supportController;
        page = const SupportScreen();
        break;
      case 1:
        controller = _accountController;
        page = const LoginScreen();
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

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );

    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Color(0xFFD9D9D9),
        border: Border(top: BorderSide(color: Color(0xFF2A2A2A))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          Transform.scale(
            scale: widget.currentIndex == 0 ? 1.3 : 1.0,
            child: ScaleTransition(
              scale: _supportScale,
              child: IconButton(
                icon: const Icon(Icons.headset_mic_outlined,
                    color: Colors.black87, size: 32),
                onPressed: () => _navigate(0),
              ),
            ),
          ),

          Transform.scale(
            scale: widget.currentIndex == 1 ? 1.3 : 1.0,
            child: ScaleTransition(
              scale: _accountScale,
              child: IconButton(
                icon: const Icon(Icons.account_circle,
                    color: Colors.black87, size: 38),
                onPressed: () => _navigate(1),
              ),
            ),
          ),

          Transform.scale(
            scale: widget.currentIndex == 2 ? 1.3 : 1.0,
            child: ScaleTransition(
              scale: _settingsScale,
              child: IconButton(
                icon: const Icon(Icons.settings_outlined,
                    color: Colors.black87, size: 32),
                onPressed: () => _navigate(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
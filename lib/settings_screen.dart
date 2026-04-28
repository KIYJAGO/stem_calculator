import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Preferences',
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
          children: [
            _buildItem(
              title: 'Language',
              value: 'English',
              onTap: () {},
            ),

            _divider(),

            _buildItem(
              title: 'Theme',
              value: 'Dark',
              onTap: () {},
            ),

            _divider(),
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
              icon: const Icon(Icons.account_circle, color: Colors.black87, size: 32),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.black87, size: 42),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  // Item
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
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Courier',
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontFamily: 'Courier',
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right,
                    color: Colors.white54, size: 18),
              ],
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
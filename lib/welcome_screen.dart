import 'package:flutter/material.dart';
import 'package:stem_calc/bottom_nav.dart';
import 'package:stem_calc/home_screen.dart';
import 'login_screen.dart';
import 'user_session.dart';
import 'settings_screen.dart';
import 'support_screen.dart';
import 'api.dart';

class WelcomeScreen extends StatelessWidget {
  final String? username; 

  const WelcomeScreen({super.key, this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Widget destinationPage;

            switch (UserSession.lastTabIndex) {
              case 0:
                destinationPage = const SupportScreen();
                break;
              case 2:
                destinationPage = const SettingsScreen();
                break;
              case 1:
                destinationPage = const HomeScreen();
                break;
              default:
                destinationPage = const HomeScreen();
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => destinationPage),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                UserSession.clear();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Courier',
                ),
              ),
            ),
          ),
        ],
      ),

      // ✅ CHANGED: Wrapped in SingleChildScrollView to support multiple boxes safely without overflowing pixels
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${username ?? "User"}!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'Courier',
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Learn something new on STEM Calc.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontFamily: 'Courier',
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontFamily: 'Courier',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ── BOX 1: FAVORITE FORMULAS ─────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white38),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.bookmark, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Favourite Formula',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Courier',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  FutureBuilder<List<String>>(
                    future: ApiService().getFavoriteFormulas(UserSession.userId ?? ""),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'No favorite formulas added yet.',
                            style: TextStyle(color: Colors.white54, fontFamily: 'Courier', fontSize: 12),
                          ),
                        );
                      }

                      List<dynamic> formulas = snapshot.data!;
                      return Column(
                        children: List.generate(formulas.length, (index) {
                          final f = formulas[index];
                          return Column(
                            children: [
                              _item("${f["name"]} — ${f["formula"]}"),
                              if (index < formulas.length - 1) _divider(),
                            ],
                          );
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ✅ BOX 2: ADDED CALCULATION HISTORY
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white38),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.calculate, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Calculation History',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Courier',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  FutureBuilder<List<dynamic>>(
                    future: ApiService().getUserHistory(UserSession.username ?? ""),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'No history saved yet.',
                            style: TextStyle(color: Colors.white54, fontFamily: 'Courier', fontSize: 12),
                          ),
                        );
                      }

                      List<dynamic> history = snapshot.data!;
                      return Column(
                        children: List.generate(history.length, (index) {
                          final h = history[index];
                          return Column(
                            children: [
                              _item(h["calculation"] ?? ""),
                              if (index < history.length - 1) _divider(),
                            ],
                          );
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ── DELETE ACCOUNT BUTTON ────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        backgroundColor: const Color(0xFF1A1A1A),
                        title: const Text('Hapus Akun', 
                          style: TextStyle(color: Colors.white, fontFamily: 'Courier')),
                        content: const Text(
                          'Apakah Anda yakin ingin menghapus akun secara permanen? Semua data formula favorit Anda akan hilang.', 
                          style: TextStyle(color: Colors.white70, fontFamily: 'Courier')),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('Batal', style: TextStyle(color: Colors.white54, fontFamily: 'Courier')),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(dialogContext);
                              
                              bool success = await ApiService().deleteAccount(UserSession.userId ?? "");
                              
                              if (success) {
                                UserSession.username = null;
                                UserSession.userId = null;
                                
                                if (!context.mounted) return;
                                
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                                );
                              } else {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Gagal menghapus akun. Coba lagi.")),
                                );
                              }
                            },
                            child: const Text('Hapus', style: TextStyle(color: Colors.red, fontFamily: 'Courier')),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  'Hapus Akun Saya',
                  style: TextStyle(fontFamily: 'Courier'),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }

  Widget _item(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontFamily: 'Courier',
                fontSize: 12,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white54, size: 18),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      color: Colors.white24,
    );
  }
}
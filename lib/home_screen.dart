import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stem_calc/bottom_nav.dart';
import 'package:stem_calc/calculator/base_calculator_screen.dart';
import 'explore_screen.dart';
import 'admin_screen.dart';
import 'user_session.dart';

class SubjectCard {
  final String label;
  final Color color;
  final Widget icon;

  const SubjectCard({
    required this.label,
    required this.color,
    required this.icon,
  });
}

// Card list
final List<SubjectCard> subjectCards = [
  SubjectCard(
    label: 'Math',
    color: const Color(0xFF7B1E1E),
    icon: SvgPicture.asset('assets/icons/Math.svg', width: 72, height: 72),
  ),
  SubjectCard(
    label: 'Physics',
    color: const Color(0xFF1A3A5C),
    icon: SvgPicture.asset('assets/icons/Physics.svg', width: 72, height: 72),
  ),
  SubjectCard(
    label: 'Biology',
    color: const Color(0xFF2D5A27),
    icon: SvgPicture.asset('assets/icons/Biology.svg', width: 72, height: 72),
  ),
  SubjectCard(
    label: 'Chemistry',
    color: const Color(0xFF5B2D8E),
    icon: SvgPicture.asset('assets/icons/Chemistry.svg', width: 72, height: 72),
  ),
  SubjectCard(
    label: 'Statistic',
    color: const Color(0xFF6B3A1F),
    icon: SvgPicture.asset('assets/icons/Statistic.svg', width: 72, height: 72),
  ),
  SubjectCard(
    label: 'Computing',
    color: const Color(0xFF6B7A1F),
    icon: SvgPicture.asset('assets/icons/Computing.svg', width: 72, height: 72),
  ),
];

// Home
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Stem Calc',
          style: TextStyle(
            fontFamily: 'Courier',
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
        if (UserSession.isAdmin)
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: IconButton(
            icon: const Icon(Icons.admin_panel_settings, color: Color(0xFFE59400)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminScreen()),
              );
            },
          ),
        ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.search_outlined, color: Colors.white70),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ExploreScreen()),
                );
              },
            ),
          ),
        ],
      ),

      // Grid
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: GridView.builder(
          itemCount: subjectCards.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            return _SubjectCardWidget(card: subjectCards[index]);
          },
        ),
        
      ),

      bottomNavigationBar: const BottomNav(currentIndex: 3,),
    );
  }
}

// Card widget
class _SubjectCardWidget extends StatelessWidget {
  final SubjectCard card;
  const _SubjectCardWidget({required this.card});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BaseCalculatorScreen(card: card)),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: card.color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(child: card.icon),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            card.label,
            style: const TextStyle(
              fontFamily: 'Courier',
              fontSize: 14,
              color: Color(0xFFE59400),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
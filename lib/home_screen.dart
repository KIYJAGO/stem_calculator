import 'package:flutter/material.dart';

class SubjectCard {
  final String label;
  final Color color;
  final Widget icon; // swap in your SVG here later

  const SubjectCard({
    required this.label,
    required this.color,
    required this.icon,
  });
}

final List<SubjectCard> subjectCards = [
  SubjectCard(
    label: 'Math',
    color: const Color(0xFF7B1E1E), // dark red
    icon: _placeholderIcon(),       // replace with: SvgPicture.asset('assets/icons/math.svg')
  ),
  SubjectCard(
    label: 'Physics',
    color: const Color(0xFF1A3A5C), // dark blue
    icon: _placeholderIcon(),
  ),
  SubjectCard(
    label: 'Biology',
    color: const Color(0xFF2D5A27), // green
    icon: _placeholderIcon(),
  ),
  SubjectCard(
    label: 'Chemistry',
    color: const Color(0xFF5B2D8E), // purple
    icon: _placeholderIcon(),
  ),
  SubjectCard(
    label: 'Statistic',
    color: const Color(0xFF6B3A1F), // brown
    icon: _placeholderIcon(),
  ),
  SubjectCard(
    label: 'Computing',
    color: const Color(0xFF6B7A1F), // olive green
    icon: _placeholderIcon(),
  ),
];

Widget _placeholderIcon() {
  return const Icon(Icons.image_outlined, color: Colors.white54, size: 48);
}

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
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 26),
            onPressed: () {},
          ),
        ],
      ),

      // ── GRID ──
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: GridView.builder(
          itemCount: subjectCards.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,       // 2 columns
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.0,   // square cards
          ),
          itemBuilder: (context, index) {
            return _SubjectCardWidget(card: subjectCards[index]);
          },
        ),
      ),

      // ── BOTTOM NAV ──
      bottomNavigationBar: _BottomNav(),
    );
  }
}

class _SubjectCardWidget extends StatelessWidget {
  final SubjectCard card;
  const _SubjectCardWidget({required this.card});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: navigate to subject screen
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Colored rounded box
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
          // Label
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

// ─────────────────────────────────────────
// BOTTOM NAV BAR
// ─────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(top: BorderSide(color: Color(0xFF2A2A2A))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.headset_outlined, color: Colors.white70),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white, size: 32),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
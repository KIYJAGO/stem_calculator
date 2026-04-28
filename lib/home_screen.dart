import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'settings_screen.dart';
import 'support_screen.dart';

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

final List<SubjectCard> subjectCards = [
  SubjectCard(
    label: 'Math',
    color: const Color(0xFF7B1E1E), 
    icon: _placeholderIcon(),       // next replace: SvgPicture.asset('assets/icons/math.svg')
  ),
  SubjectCard(
    label: 'Physics',
    color: const Color(0xFF1A3A5C),
    icon: _placeholderIcon(),
  ),
  SubjectCard(
    label: 'Biology',
    color: const Color(0xFF2D5A27),
    icon: _placeholderIcon(),
  ),
  SubjectCard(
    label: 'Chemistry',
    color: const Color(0xFF5B2D8E),
    icon: _placeholderIcon(),
  ),
  SubjectCard(
    label: 'Statistic',
    color: const Color(0xFF6B3A1F),
    icon: _placeholderIcon(),
  ),
  SubjectCard(
    label: 'Computing',
    color: const Color(0xFF6B7A1F),
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

      // Grid
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

// Navbar bottom
class _BottomNav extends StatefulWidget {
  @override
  State<_BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<_BottomNav>
    with TickerProviderStateMixin {

  late AnimationController _iconController;
  late AnimationController _settingsController;
  late AnimationController _supportController;

  late Animation<double> _iconScale;
  late Animation<double> _settingsScale;
  late Animation<double> _supportScale;

  @override
  void initState() {
    super.initState();

    _iconController = AnimationController(
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

    _iconScale = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: Curves.elasticOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    _settingsScale = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _settingsController,
        curve: Curves.elasticOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    _supportScale = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _supportController,
        curve: Curves.elasticOut,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    _settingsController.dispose();
    _supportController.dispose();
    super.dispose();
  }

  void _onAccountTap() async {
    await _iconController.forward();
    if (mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
    _iconController.reverse();
  }

  void _onSettingsTap() async {
    await _settingsController.forward();
    if (mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SettingsScreen()),
      );
    }
    _settingsController.reverse();
  }

  void _onSupportTap() async {
    await _supportController.forward();
    if (mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SupportScreen()),
      );
    }
    _supportController.reverse();
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
          GestureDetector(
            onTap: _onSupportTap,
            child: ScaleTransition(
              scale: _supportScale,
              child: const Icon(Icons.headset_mic_outlined, color: Colors.black87, size: 32),
            ),
          ),

          GestureDetector(
            onTap: _onAccountTap,
            child: ScaleTransition(
              scale: _iconScale,
              child: const Icon(Icons.account_circle, color: Colors.black87, size: 36),
            ),
          ),

          GestureDetector(
            onTap: _onSettingsTap,
            child: ScaleTransition(
              scale: _settingsScale,
              child: const Icon(Icons.settings_outlined, color: Colors.black87, size: 32)
              ),
          ),
        ],
      ),
    );
  }
}
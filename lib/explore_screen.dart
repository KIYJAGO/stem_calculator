import 'package:flutter/material.dart';
import 'bottom_nav.dart';
import 'search_result_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'calculator/math_calculator.dart';
// import 'calculator/biology_calculator.dart';

class FormulaItem {
  final String title;
  const FormulaItem({required this.title});
}
final List<FormulaItem> popularFormulas = [
  FormulaItem(title: 'How to count 19 Million Job Vacancy'),
  FormulaItem(title: 'Formula to count State Debt'),
  FormulaItem(title: 'Count Sins from the previous President'),
];

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

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
        title: const Text(
          'Explore',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Courier',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 12),

            // Search bar
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                );
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF333333)),
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 12),
                    Icon(Icons.search, color: Colors.white54, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Find formula',
                      style: TextStyle(
                        color: Colors.white38,
                        fontFamily: 'Courier',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Calculator
            const Text(
              'Calculator',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Courier',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            // Calculator cards
            SizedBox(
              height: 140,
              child: Row(
                children: [
                  Expanded(
                    child: _SmallSubjectCard(
                      label: 'Math',
                      color: const Color(0xFF7B1E1E),
                      icon: SvgPicture.asset(
                        'assets/icons/Math.svg',
                        width: 40,
                        height: 40,
                      ),
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => const MathCalculator(),
                        //   ),
                        // );
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _SmallSubjectCard(
                      label: 'Biology',
                      color: const Color(0xFF2D5A27),
                      icon: SvgPicture.asset(
                        'assets/icons/Biology.svg',
                        width: 40,
                        height: 40,
                      ),
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => const BiologyCalculator()
                        //   ),
                        // );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Popular formula
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular Formula',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Courier',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     // TODO: add formula
                //   },
                //   child: const Row(
                //     children: [
                //       Icon(Icons.add_circle_outline,
                //           color: Colors.white54, size: 18),
                //       SizedBox(width: 4),
                //       Text(
                //         'Add',
                //         style: TextStyle(
                //           color: Colors.white54,
                //           fontFamily: 'Courier',
                //           fontSize: 13,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),

            const SizedBox(height: 12),

            // Formula list
            ...popularFormulas.map((formula) => _FormulaRow(formula: formula)),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 3),
    );
  }
}

// Small subject card
class _SmallSubjectCard extends StatelessWidget {
  final String label;
  final Color color;
  final Widget icon;
  final VoidCallback? onTap;

  const _SmallSubjectCard({
    required this.label,
    required this.color,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Courier',
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Formula row
class _FormulaRow extends StatelessWidget {
  final FormulaItem formula;
  const _FormulaRow({required this.formula});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  formula.title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontFamily: 'Courier',
                    fontSize: 13,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white38),
            ],
          ),
        ),
        const Divider(color: Color(0xFF2A2A2A), height: 1),
      ],
    );
  }
}
import 'package:flutter/material.dart';

class FAQAccountSecurity extends StatelessWidget {
  const FAQAccountSecurity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "FAQ",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Courier",
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Home / Help Center / Calculator FAQ",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 30),

          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              initiallyExpanded: true,
              iconColor: const Color(0xFFE59400),
              collapsedIconColor: const Color(0xFFE59400),
              title: const Text(
                "Calculator",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              childrenPadding: const EdgeInsets.only(left: 20),
              children: const [
                _FAQItem("Basic Calculations"),
                _FAQItem("Scientific Calculator"),
                _FAQItem("Unit Converter"),
                _FAQItem("Formula Library"),
                _FAQItem("Graph Calculator"),
                _FAQItem("Calculation History"),
              ],
            ),
          ),

          const Divider(color: Colors.white24),

          const _CategoryTile("Account"),
          const _CategoryTile("Favorites"),
          const _CategoryTile("Language Settings"),
          const _CategoryTile("Troubleshooting"),
          const _CategoryTile("About STEM Calc"),
        ],
      ),
    );
  }
}

class _FAQItem extends StatelessWidget {
  final String title;

  const _FAQItem(this.title);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 18,
        ),
      ),
      onTap: () {},
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String title;

  const _CategoryTile(this.title);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      iconColor: const Color(0xFFE59400),
      collapsedIconColor: const Color(0xFFE59400),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      children: const [],
    );
  }
}
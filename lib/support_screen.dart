import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),

      // ── APP BAR ──
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'STEM Support',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Courier',
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),

      // ── BODY ──
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── TOP QUESTIONS ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Top questions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Courier',
                  ),
                ),
                Icon(Icons.refresh, color: Colors.white70),
              ],
            ),

            const SizedBox(height: 16),

            _buildQuestionButton('Formula to count State Debt'),
            const SizedBox(height: 10),
            _buildQuestionButton('How to count 19 Million Job Vacancy'),
            const SizedBox(height: 10),
            _buildQuestionButton(
                'Count President Foreign Visits since office'),

            const SizedBox(height: 30),

            // ── FAQ ──
            const Text(
              'FAQ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Courier',
              ),
            ),

            const SizedBox(height: 10),

            _buildFAQItem('Account & Security'),
            _divider(),
            _buildFAQItem('How to use calculator'),
            _divider(),
            _buildFAQItem("How to find formula that doesn't exist"),
            _divider(),
          ],
        ),
      ),

      // ── BOTTOM NAV ──
      bottomNavigationBar: Container(
        height: 64,
        decoration: const BoxDecoration(
          color: Color(0xFFD9D9D9),
          border: Border(top: BorderSide(color: Color(0xFF2A2A2A))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(Icons.headset_outlined, color: Colors.black87, size: 42),
            const Icon(Icons.account_circle, color: Colors.black87, size: 32),
            const Icon(Icons.settings_outlined, color: Colors.black87),
          ],
        ),
      ),
    );
  }

  // ── TOP QUESTION BUTTON ──
  Widget _buildQuestionButton(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white38),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontFamily: 'Courier',
        ),
      ),
    );
  }

  // ── FAQ ITEM ──
  Widget _buildFAQItem(String text) {
    return InkWell(
      onTap: () {
        // TODO: navigate or expand
      },
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontFamily: 'Courier',
              ),
            ),
            const Icon(Icons.chevron_right,
                color: Colors.white54, size: 18),
          ],
        ),
      ),
    );
  }

  // ── DIVIDER ──
  Widget _divider() {
    return Container(
      height: 1,
      color: Colors.white24,
    );
  }
}
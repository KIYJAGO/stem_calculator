import 'package:flutter/material.dart';
import 'search_result_screen.dart';
import 'bottom_nav.dart';
import 'user_session.dart';
import 'api.dart';

class FormulaDetailScreen extends StatefulWidget {
  final FormulaData formula;
  const FormulaDetailScreen({super.key, required this.formula});

  @override
  State<FormulaDetailScreen> createState() => _FormulaDetailScreenState();
}

class _FormulaDetailScreenState extends State<FormulaDetailScreen> {
  bool _bookmarked = false;
  bool _saving = false;

  Future<void> _toggleBookmark() async {
    if (UserSession.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login to save formulas!")),
      );
      return;
    }

    setState(() => _saving = true);

    bool success = await ApiService().saveHistory(
      UserSession.username ?? "",
      "${widget.formula.title}: ${widget.formula.content}",
    );

    setState(() {
      _saving = false;
      if (success) _bookmarked = true;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_bookmarked ? "Formula saved!" : "Failed to save"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.search_outlined, color: Colors.white70),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.formula.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Courier',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'From: ${widget.formula.author}',
                        style: const TextStyle(
                          color: Colors.white38,
                          fontFamily: 'Courier',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFF2A2A2A),
                  child: Icon(Icons.person_outline,
                      color: Colors.white54, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2A2A2A)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Bookmark button
                    GestureDetector(
                      onTap: _saving ? null : _toggleBookmark,
                      child: _saving
                          ? const SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(
                              _bookmarked
                                  ? Icons.bookmark       // filled when saved
                                  : Icons.bookmark_outlined, // outline when not saved
                              color: _bookmarked ? Colors.amber : Colors.white70,
                              size: 28,
                            ),
                    ),

                    const SizedBox(height: 16),
                    Text(
                      widget.formula.content,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Courier',
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 3),
    );
  }
}
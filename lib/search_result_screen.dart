import 'package:flutter/material.dart';
import 'formula_detail_screen.dart';

class FormulaData {
  final String id;
  final String title;
  final String author;
  final String content;

  const FormulaData({
    required this.id,
    required this.title,
    required this.author,
    required this.content,
  });
}

final List<FormulaData> allFormulas = [
  FormulaData(
    id: '1',
    title: 'Count Debt from the previous President',
    author: 'Jusk',
    content: 'Formula content goes here...',
  ),
  FormulaData(
    id: '2',
    title: 'How to count State Debt',
    author: 'Jusk',
    content: 'Formula content goes here...',
  ),
  FormulaData(
    id: '3',
    title: 'Formula to count Debt from Debtor',
    author: 'Jusk',
    content: 'Formula content goes here...',
  ),
  FormulaData(
    id: '4',
    title: 'How to count 19 Million Job Vacancy',
    author: 'Admin',
    content: 'Formula content goes here...',
  ),
  FormulaData(
    id: '5',
    title: 'Formula to count State Debt',
    author: 'Admin',
    content: 'Formula content goes here...',
  ),
];

// Search
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<FormulaData> _results = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _results = [];
      } else {
        // DB quewry
        _results = allFormulas
          .where((f) =>
            f.title.toLowerCase().contains(query.toLowerCase()) ||
            f.author.toLowerCase().contains(query.toLowerCase()))
          .toList();
      }
    });
  }

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
        title: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Courier',
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: 'Find formula',
              hintStyle: const TextStyle(
                color: Colors.white38,
                fontFamily: 'Courier',
                fontSize: 14,
              ),
              filled: true,
              fillColor: const Color(0xFF1E1E1E),
              prefixIcon: const Icon(Icons.search, color: Colors.white54, size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.cancel,
                          color: Colors.white38, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
            ),
            onChanged: _onSearchChanged,
          ),
        ),
      ),

      // Body
      body: _searchController.text.isEmpty

      // Empty state
      ? const Center(
          child: Text(
            'Start typing to search formulas',
            style: TextStyle(
              color: Colors.white38,
              fontFamily: 'Courier',
              fontSize: 13,
            ),
          ),
        )

      // No results
      : _results.isEmpty
          ? const Center(
              child: Text(
                'No formulas found',
                style: TextStyle(
                  color: Colors.white38,
                  fontFamily: 'Courier',
                  fontSize: 13,
                ),
              ),
            )

          // Results list
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _results.length,
              separatorBuilder: (_, __) =>
                  const Divider(color: Color(0xFF2A2A2A), height: 1),
              itemBuilder: (context, index) {
                final formula = _results[index];
                return _ResultRow(
                  formula: formula,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                          FormulaDetailScreen(formula: formula),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

// Result row
class _ResultRow extends StatelessWidget {
  final FormulaData formula;
  final VoidCallback onTap;

  const _ResultRow({required this.formula, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: const CircleAvatar(
        radius: 22,
        backgroundColor: Color(0xFF2A2A2A),
        child: Icon(Icons.person_outline, color: Colors.white54, size: 22),
      ),
      title: Text(
        formula.title,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Courier',
          fontSize: 13,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.white38),
    );
  }
}
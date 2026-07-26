import 'package:flutter/material.dart';
import 'formula_detail_screen.dart';
import 'api.dart';

class FormulaData {
  final int id;
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

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _api = ApiService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  List<FormulaData> _allFormulas = [];
  List<FormulaData> _results = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLiveFormulas();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  Future<void> _fetchLiveFormulas() async {
    try {
      final List<dynamic> rawData = await _api.getFormulas();
      
      final List<FormulaData> mappedFormulas = rawData.map((f) {
        return FormulaData(
          id: int.tryParse(f["id"]?.toString() ?? "0") ?? 0,
          title: f["name"]?.toString() ?? "Untitled Formula",
          author: f["subject"]?.toString() ?? "General",
          content: "Formula: ${f["formula"]}\n\nDescription: ${f["description"] ?? ''}",
        );
      }).toList();

      setState(() {
        _allFormulas = mappedFormulas;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading search database: $e");
      setState(() {
        _isLoading = false;
      });
    }
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
        _results = _allFormulas
            .where((f) =>
                f.title.toLowerCase().contains(query.toLowerCase()) ||
                f.author.toLowerCase().contains(query.toLowerCase()) ||
                f.content.toLowerCase().contains(query.toLowerCase()))
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
              hintText: _isLoading ? 'Loading catalog...' : 'Find formula', 
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
                      icon: const Icon(Icons.cancel, color: Colors.white38, size: 18),
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
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
            onChanged: _onSearchChanged,
            enabled: !_isLoading,
          ),
        ),
      ),

      // Body configuration
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white), 
            )
          : _searchController.text.isEmpty
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
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _results.length,
                      separatorBuilder: (_, __) => const Divider(color: Color(0xFF2A2A2A), height: 1),
                      itemBuilder: (context, index) {
                        final formula = _results[index];
                        return _ResultRow(
                          formula: formula,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => FormulaDetailScreen(formula: formula),
                              ),
                            );
                          },
                        );
                      },
                    ),
    );
  }
}

// Result row layout component
class _ResultRow extends StatelessWidget {
  final FormulaData formula;
  final VoidCallback onTap;

  const _ResultRow({required this.formula, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: const CircleAvatar(
        radius: 22,
        backgroundColor: Color(0xFF2A2A2A),
        child: Icon(Icons.functions, color: Colors.white54, size: 22),
      ),
      title: Text(
        formula.title,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Courier',
          fontSize: 13,
        ),
      ),
      subtitle: Text(
        formula.author,
        style: const TextStyle(
          color: Colors.white38,
          fontFamily: 'Courier',
          fontSize: 11,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.white38),
    );
  }
}
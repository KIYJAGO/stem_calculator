import 'package:flutter/material.dart';
import 'api.dart';
import 'package:stem_calc/bottom_nav.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final ApiService _api = ApiService();
  List<dynamic> _formulas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFormulas();
  }

  Future<void> _loadFormulas() async {
    setState(() {
      _loading = true;
    });

    try {
      final formulas = await _api.getFormulas();
      if (mounted) {
        setState(() {
          _formulas = formulas;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading formulas: $e");
      if (mounted) {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to load formulas from server.',
              style: TextStyle(fontFamily: 'Courier'),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _showFormulaDialog({dynamic existing}) {
    final Map<dynamic, dynamic>? existingMap = existing is Map ? existing : null;

    final subjectController     = TextEditingController(text: existingMap?["subject"]?.toString() ?? "");
    final nameController        = TextEditingController(text: existingMap?["name"]?.toString() ?? "");
    final formulaController     = TextEditingController(text: existingMap?["formula"]?.toString() ?? "");
    final variablesController   = TextEditingController(text: existingMap?["variables"]?.toString() ?? "");
    final descriptionController = TextEditingController(text: existingMap?["description"]?.toString() ?? "");

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(
          existingMap == null ? 'Add Formula' : 'Edit Formula',
          style: const TextStyle(color: Colors.white, fontFamily: 'Courier'),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialogField(subjectController,     'Subject (e.g. Physics)'),
              _dialogField(nameController,        'Formula Name'),
              _dialogField(formulaController,     'Formula (e.g. F = m * a)'),
              _dialogField(variablesController,   'Variables (e.g. F:Force,m:Mass)'),
              _dialogField(descriptionController, 'Description'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54, fontFamily: 'Courier')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () async {

              Navigator.pop(dialogContext);

              bool success;
              int formulaId = int.tryParse(existingMap?["id"]?.toString() ?? "0") ?? 0;

              if (existingMap == null) {
                success = await _api.addFormula(
                  subjectController.text.trim(),
                  nameController.text.trim(),
                  formulaController.text.trim(),
                  variablesController.text.trim(),
                  descriptionController.text.trim(),
                );
              } else {
                success = await _api.editFormula(
                  formulaId,
                  subjectController.text.trim(),
                  nameController.text.trim(),
                  formulaController.text.trim(),
                  variablesController.text.trim(),
                  descriptionController.text.trim(),
                );
              }

              if (!mounted) return;

              if (success) {
                _loadFormulas();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      existingMap == null ? "Formula added!" : "Formula updated!",
                      style: const TextStyle(fontFamily: 'Courier'),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      existingMap == null ? "Failed to add formula." : "Failed to update formula.",
                      style: const TextStyle(fontFamily: 'Courier'),
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: Text(
              existingMap == null ? 'Add' : 'Save',
              style: const TextStyle(color: Colors.black, fontFamily: 'Courier'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dialogField(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontFamily: 'Courier'),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38, fontFamily: 'Courier'),
          filled: true,
          fillColor: const Color(0xFF2A2A2A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
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
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Admin Formulas',
          style: TextStyle(color: Colors.white, fontFamily: 'Courier'),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _formulas.isEmpty
              ? const Center(
                  child: Text(
                    'No formulas yet.\nTap + to add one.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54, fontFamily: 'Courier'),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _formulas.length,
                  itemBuilder: (context, index) {
                    final f = _formulas[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  f["name"]?.toString() ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Courier',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  f["formula"]?.toString() ?? "",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontFamily: 'Courier',
                                  ),
                                ),
                                Text(
                                  f["subject"]?.toString() ?? "",
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontFamily: 'Courier',
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white54),
                            onPressed: () => _showFormulaDialog(existing: f),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () async {
                              int id = int.tryParse(f["id"]?.toString() ?? "0") ?? 0;
                              bool success = await _api.deleteFormula(id);
                              
                              if (context.mounted) {
                                if (success) {
                                  _loadFormulas();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Formula deleted!", style: TextStyle(fontFamily: 'Courier')),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Failed to delete formula.", style: TextStyle(fontFamily: 'Courier')),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => _showFormulaDialog(),
        child: const Icon(Icons.add, color: Colors.black),
      ),

      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }
}
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
    final formulas = await _api.getFormulas();
    
    setState(() {
      _formulas = formulas;
      _loading = false;
    });
  }

  void _showFormulaDialog({Map<String, dynamic>? existing}) {
    final subjectController     = TextEditingController(text: existing?["subject"] ?? "");
    final nameController        = TextEditingController(text: existing?["name"] ?? "");
    final formulaController     = TextEditingController(text: existing?["formula"] ?? "");
    final variablesController   = TextEditingController(text: existing?["variables"] ?? "");
    final descriptionController = TextEditingController(text: existing?["description"] ?? "");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(
          existing == null ? 'Add Formula' : 'Edit Formula',
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () async {
              bool success;
              if (existing == null) {
                success = await _api.addFormula(
                  subjectController.text.trim(),
                  nameController.text.trim(),
                  formulaController.text.trim(),
                  variablesController.text.trim(),
                  descriptionController.text.trim(),
                );
              } else {
                success = await _api.editFormula(
                 int.parse(existing["id"].toString()),
                  subjectController.text.trim(),
                  nameController.text.trim(),
                  formulaController.text.trim(),
                  variablesController.text.trim(),
                  descriptionController.text.trim(),
                );
              }

              if (!mounted) return;
              Navigator.pop(context);

              if (success) {
                _loadFormulas();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(existing == null ? "Formula added!" : "Formula updated!")),
                );
              }
            },
            child: Text(
              existing == null ? 'Add' : 'Save',
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
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const BottomNav(currentIndex: 0)),
              );
            }
          },
        ),
        title: const Text(
          'Admin Formulas',
          style: TextStyle(color: Colors.white, fontFamily: 'Courier'),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
        ],
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
                                  f["name"] ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Courier',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  f["formula"] ?? "",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontFamily: 'Courier',
                                  ),
                                ),
                                Text(
                                  f["subject"] ?? "",
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
                              bool success = await _api.deleteFormula(
                                int.tryParse(f["id"]?.toString() ?? "0") ?? 0,
                              );
                              if (success) {
                                _loadFormulas();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Formula deleted!")),
                                );
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
    );
  }
}
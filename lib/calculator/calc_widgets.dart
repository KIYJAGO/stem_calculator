import 'package:flutter/material.dart';
import 'dart:math' as math;
// import 'package:stem_calc/api.dart';
// import 'package:stem_calc/user_session.dart';

// ─── Format number ─────────────────────────────────────────────────────────
String fmtNum(double v) {
  if (v.isInfinite) return v > 0 ? '∞' : '-∞';
  if (v.isNaN) return 'Error';
  if (v == v.truncateToDouble() && v.abs() < 1e15) return v.toStringAsFixed(0);
  String s = v.toStringAsFixed(10);
  s = s.replaceAll(RegExp(r'0+$'), '');
  s = s.replaceAll(RegExp(r'\.$'), '');
  return s;
}

// ─── Key types ─────────────────────────────────────────────────────────────
enum KeyType {
  digit, dot, opPlus, opMinus, opMul, opDiv,
  equal, clear, backspace, sign, percent,
  sqrt_, power, specialFn, openParen, closeParen,
  bracket, sigma, custom,
}

class CalcKey {
  final String label;
  final KeyType type;
  const CalcKey(this.label, this.type);
}

// ─── Calculator Engine ─────────────────────────────────────────────────────
class CalcEngine extends ChangeNotifier {
  String _display = '0';
  String _expression = '';
  double? _firstOperand;
  String? _pendingOp;
  bool _awaitingSecond = false;
  final List<String> history = [];

  String get display => _display;
  String get expression => _expression;

  void inputDigit(String d) {
    if (_awaitingSecond) {
      _display = d;
      _awaitingSecond = false;
    } else {
      _display = _display == '0' ? d : _display + d;
    }
    notifyListeners();
  }

  void inputDot() {
    if (_awaitingSecond) { _display = '0.'; _awaitingSecond = false; }
    else if (!_display.contains('.')) _display += '.';
    notifyListeners();
  }

  void inputOp(String op) {
    _firstOperand = double.tryParse(_display) ?? 0;
    _pendingOp = op;
    _awaitingSecond = true;
    _expression = '$_display $op';
    notifyListeners();
  }

  String? calculate() {
    if (_firstOperand == null || _pendingOp == null) return null;
    final second = double.tryParse(_display) ?? 0;
    double result;
    switch (_pendingOp) {
      case '+': result = _firstOperand! + second; break;
      case '−': result = _firstOperand! - second; break;
      case '×': result = _firstOperand! * second; break;
      case '÷':
        if (second == 0) { _setDisplay('Error'); notifyListeners(); return 'Error'; }
        result = _firstOperand! / second; break;
      case '^': result = math.pow(_firstOperand!, second).toDouble(); break;
      default: return null;
    }
    final res = fmtNum(result);
    _addHistory('${_expression} $_display = $res');
    _setDisplay(res);
    _firstOperand = result;
    _pendingOp = null;
    _awaitingSecond = true;
    _expression = '';
    notifyListeners();
    return res;
  }

  void setDisplayResult(String res, String historyEntry) {
    if (historyEntry.isNotEmpty) _addHistory(historyEntry);
    _setDisplay(res);
    _firstOperand = double.tryParse(res);
    _awaitingSecond = true;
    _expression = '';
    notifyListeners();
  }

  void clear() {
    _display = '0'; _expression = ''; _firstOperand = null;
    _pendingOp = null; _awaitingSecond = false;
    notifyListeners();
  }

  void backspace() {
    if (_display.length <= 1 || _display == 'Error') _display = '0';
    else _display = _display.substring(0, _display.length - 1);
    notifyListeners();
  }

  void toggleSign() {
    if (_display.startsWith('-')) _display = _display.substring(1);
    else if (_display != '0') _display = '-$_display';
    notifyListeners();
  }

  void percent() {
    final v = double.tryParse(_display);
    if (v != null) _display = fmtNum(v / 100);
    notifyListeners();
  }

  void sqrtOp() {
    final v = double.tryParse(_display) ?? 0;
    final res = v < 0 ? 'Error' : fmtNum(math.sqrt(v));
    _addHistory('√$_display = $res');
    _setDisplay(res);
    _awaitingSecond = true;
    notifyListeners();
  }

  void powerOp() => inputOp('^');

  void _setDisplay(String s) => _display = s;
  void _addHistory(String entry) {
    history.insert(0, entry);
    if (history.length > 50) history.removeLast();
  }
}

// ─── Base Calculator Screen ────────────────────────────────────────────────
class SubjectCalculatorBase extends StatefulWidget {
  final Color subjectColor;
  final String subjectLabel;
  final List<String> categories;
  final Map<String, String> categoryUnits;
  final List<CalcKey> Function(String category) specialKeysFor;
  final String Function(String category, String display, CalcEngine engine) onEqual;

  const SubjectCalculatorBase({
    super.key,
    required this.subjectColor,
    required this.subjectLabel,
    required this.categories,
    this.categoryUnits = const {},
    required this.specialKeysFor,
    required this.onEqual,
  });

  @override
  State<SubjectCalculatorBase> createState() => _SubjectCalculatorBaseState();
}

class _SubjectCalculatorBaseState extends State<SubjectCalculatorBase> {
  late String _category;
  final CalcEngine _engine = CalcEngine();
  bool _showHistory = false;

  @override
  void initState() {
    super.initState();
    _category = widget.categories.first;
    _engine.addListener(() => setState(() {}));
  }

  @override
  void dispose() { _engine.dispose(); super.dispose(); }

  String get _unit => widget.categoryUnits[_category] ?? '';

  void _handleKey(CalcKey k) {
    switch (k.type) {
      case KeyType.digit:     _engine.inputDigit(k.label); break;
      case KeyType.dot:       _engine.inputDot(); break;
      case KeyType.opPlus:    _engine.inputOp('+'); break;
      case KeyType.opMinus:   _engine.inputOp('−'); break;
      case KeyType.opMul:     _engine.inputOp('×'); break;
      case KeyType.opDiv:     _engine.inputOp('÷'); break;
      case KeyType.sign:      _engine.toggleSign(); break;
      case KeyType.percent:   _engine.percent(); break;
      case KeyType.clear:     _engine.clear(); break;
      case KeyType.backspace: _engine.backspace(); break;
      case KeyType.sqrt_:     _engine.sqrtOp(); break;
      case KeyType.power:     _engine.powerOp(); break;
      case KeyType.bracket:   _engine.inputDigit('[]'); break;
      case KeyType.openParen:
        if (_engine.display == '0') _engine.setDisplayResult('(', '');
        else _engine.inputDigit('(');
        break;
      case KeyType.closeParen: _engine.inputDigit(')'); break;
      case KeyType.equal:
        final o = widget.onEqual(_category, _engine.display, _engine);
        if (o.isEmpty) _engine.calculate();
        break;
      case KeyType.specialFn:
        final o = widget.onEqual('${_category}__${k.label}', _engine.display, _engine);
        if (o.isEmpty) _engine.calculate();
        break;
      default: break;
    }
  }

  void _showCategoryMenu() async {
    final size = MediaQuery.of(context).size;
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset offset = box.localToGlobal(Offset.zero);
    final double boxHeight = box.size.height;


    final result = await showMenu<String>(
      context: context,
      color: const Color(0xFF1A1A1A),
      position: RelativeRect.fromLTRB(
        size.width * 0.30,
        offset.dy + boxHeight * 0.09,
        size.width * 0.70,
        0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      items: widget.categories.map((c) => PopupMenuItem(
        value: c,
      child: Center(
        child: Text(
          c,
          style: TextStyle(
            fontFamily: 'Courier',
            fontSize: 16,
            color: c == _category ? const Color(0xFFFF6B6B) : Colors.white70,
            fontWeight: c == _category ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
      )).toList(),
    );
    if (result != null) setState(() { _category = result; _engine.clear(); });
  }

  Color _accentColor() {
    final c = widget.subjectColor;
    if (c == const Color(0xFF7B1E1E)) return const Color(0xFFFF6B6B);
    if (c == const Color(0xFF1A3A5C)) return const Color(0xFF64B5F6);
    if (c == const Color(0xFF2D5A27)) return const Color(0xFF81C784);
    if (c == const Color(0xFF5B2D8E)) return const Color(0xFFCE93D8);
    if (c == const Color(0xFF6B3A1F)) return const Color(0xFFFFB74D);
    if (c == const Color(0xFF6B7A1F)) return const Color(0xFFDCE775);
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.subjectColor;
    final accent = _accentColor();
    final List<CalcKey> specialKeys = widget.specialKeysFor(_category);

    return Column(
      children: [

        // ════════════════════════════════════════════════════
        // OUTPUT — flex: 2 = 40% tinggi layar
        // ════════════════════════════════════════════════════
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            color: color,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dropdown kategori di tengah
                Center(
                  child: GestureDetector(
                    onTap: _showCategoryMenu,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _category,
                          style: TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 18,
                            color: accent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down_rounded, color: accent, size: 20),
                      ],
                    ),
                  ),
                ),
                // Isi sisa ruang dengan angka di bawah
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_engine.expression.isNotEmpty)
                        Text(
                          _engine.expression,
                          style: const TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 14,
                            color: Colors.white54,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _engine.display,
                                style: const TextStyle(
                                  fontFamily: 'Verdana',
                                  fontSize: 64,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          if (_unit.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Text(
                              _unit,
                              style: const TextStyle(
                                fontFamily: 'Verdana',
                                fontSize: 50,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                          // Kursor
                          Container(
                            width: 2,
                            height: 52,
                            color: Colors.white,
                            margin: const EdgeInsets.only(left: 4),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
               // ── History bar ───────────────────────────────────────────────
        Container(
          color: const Color(0xFF0F0F0F),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => setState(() => _showHistory = !_showHistory),
                child: const Icon(Icons.history_rounded, color: Colors.white38, size: 26),
              ),
              GestureDetector(
                onTap: () => _handleKey(const CalcKey('⌫', KeyType.backspace)),
                child: const Icon(Icons.backspace_outlined, color: Color(0xFFE57373), size: 24),
              ),
            ],
          ),
        ),

        // ── History list ──────────────────────────────────────────────
        if (_showHistory && _engine.history.isNotEmpty)
          Container(
            color: const Color(0xFF111111),
            height: 88,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              itemCount: _engine.history.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  _engine.history[i],
                  style: const TextStyle(fontFamily: 'Courier', fontSize: 11, color: Colors.white38),
                ),
              ),
            ),
          ),
        // ── History list ──────────────────────────────────────────────
        // if (_showHistory && _engine.history.isNotEmpty)
        //   Container(
        //     color: const Color(0xFF111111),
        //     height: 120,
        //     child: ListView.builder(
        //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        //       itemCount: _engine.history.length,
        //       itemBuilder: (context, i) {
        //         final calculationItem = _engine.history[i];
                
        //         return Padding(
        //           padding: const EdgeInsets.only(bottom: 6),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [

        //               Expanded(
        //                 child: Text(
        //                   calculationItem,
        //                   style: const TextStyle(fontFamily: 'Courier', fontSize: 11, color: Colors.white38),
        //                 ),
        //               ),

        //               IconButton(
        //                 icon: const Icon(Icons.bookmark_add_outlined, color: Colors.white54, size: 16),
        //                 padding: EdgeInsets.zero,
        //                 constraints: const BoxConstraints(),
        //                 tooltip: 'Save to profile',
        //                 onPressed: () async {

        //                   if (!UserSession.isLoggedIn || UserSession.username == null) {
        //                     ScaffoldMessenger.of(context).showSnackBar(
        //                       const SnackBar(content: Text('Please log in to save history!')),
        //                     );
        //                     return;
        //                   }

        //                   final ApiService api = ApiService();
        //                   bool success = await api.saveCalculationHistory(
        //                     UserSession.username!, 
        //                     calculationItem,
        //                   );

        //                   if (context.mounted) {
        //                     ScaffoldMessenger.of(context).showSnackBar(
        //                       SnackBar(
        //                         content: Text(success 
        //                           ? 'Calculation saved to profile! 💾' 
        //                           : 'Failed to save calculation.'),
        //                         backgroundColor: success ? Colors.green : Colors.redAccent,
        //                         duration: const Duration(seconds: 1),
        //                       ),
        //                     );
        //                   }
        //                 },
        //               ),
        //             ],
        //           ),
        //         );
        //       },
        //     ),
        //   ),

        // ════════════════════════════════════════════════════
        // KEYPAD — flex: 3 = 60% tinggi layar
        // ════════════════════════════════════════════════════
        Expanded(
          flex: 3,
          child: Container(
            color: const Color(0xFF1A1A1A),
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
            child: Column(
              children: [
                // Row special: C  √  ^  %  +
                Expanded(child: _buildRow(specialKeys, color)),
                // Row: 1  2  3  +/-  −
                Expanded(child: _buildRow([
                  const CalcKey('1', KeyType.digit),
                  const CalcKey('2', KeyType.digit),
                  const CalcKey('3', KeyType.digit),
                  const CalcKey('+/-', KeyType.sign),
                  const CalcKey('−', KeyType.opMinus),
                ], color)),
                // Row: 4  5  6  ( )  ÷
                Expanded(child: _buildRow([
                  const CalcKey('4', KeyType.digit),
                  const CalcKey('5', KeyType.digit),
                  const CalcKey('6', KeyType.digit),
                  const CalcKey('()', KeyType.openParen),
                  const CalcKey('÷', KeyType.opDiv),
                ], color)),
                // Row: 7  8  9  [ ]  ×
                Expanded(child: _buildRow([
                  const CalcKey('7', KeyType.digit),
                  const CalcKey('8', KeyType.digit),
                  const CalcKey('9', KeyType.digit),
                  const CalcKey('[]', KeyType.bracket),
                  const CalcKey('×', KeyType.opMul),
                ], color)),
                // Row: ABC  0  .  =
                Expanded(child: _buildBottomRow(color)),
              ],
            ),
          ),
        ),

      ],
    );
  }

  Widget _buildRow(List<CalcKey> keys, Color color) {
    return Row(
      children: keys.map((k) => Expanded(
        child: _KeyBtn(k: k, subjectColor: color, onTap: () => _handleKey(k)),
      )).toList(),
    );
  }

  Widget _buildBottomRow(Color color) {
    return Row(
      children: [
        Expanded(child: _KeyBtn(k: const CalcKey('ABC', KeyType.custom), subjectColor: color, onTap: () {})),
        Expanded(child: _KeyBtn(k: const CalcKey('0', KeyType.digit), subjectColor: color, onTap: () => _handleKey(const CalcKey('0', KeyType.digit)))),
        Expanded(child: _KeyBtn(k: const CalcKey('.', KeyType.dot), subjectColor: color, onTap: () => _handleKey(const CalcKey('.', KeyType.dot)))),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: GestureDetector(
              onTap: () => _handleKey(const CalcKey('=', KeyType.equal)),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE59400),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFFE59400).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '=',
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Key Button Widget ─────────────────────────────────────────────────────
class _KeyBtn extends StatelessWidget {
  final CalcKey k;
  final Color subjectColor;
  final VoidCallback onTap;

  const _KeyBtn({required this.k, required this.subjectColor, required this.onTap});

  // Apakah tombol ini punya background circle?
  bool get _hasCircle {
    switch (k.type) {
      case KeyType.digit:  return true; // angka — circle merah
      case KeyType.clear:  return true; // C — circle merah
      case KeyType.custom: return true; // ABC — circle gelap
      case KeyType.dot:    return true; // . — circle gelap
      default:             return false; // operator & fn — TANPA circle
    }
  }

  Color _bgColor() {
    switch (k.type) {
      case KeyType.digit:  return subjectColor;
      case KeyType.clear:  return subjectColor;
      case KeyType.custom: return const Color(0xFF2A2A2A);
      case KeyType.dot:    return const Color(0xFF2A2A2A);
      default:             return Colors.transparent;
    }
  }

  Color _fgColor() {
    switch (k.type) {
      case KeyType.digit:   return Colors.white;
      case KeyType.clear:   return const Color(0xFFE59400);
      case KeyType.opPlus:
      case KeyType.opMinus:
      case KeyType.opMul:
      case KeyType.opDiv:   return const Color(0xFF4CAF50);
      case KeyType.sqrt_:
      case KeyType.power:
      case KeyType.percent:
      case KeyType.sign:
      case KeyType.specialFn:
      case KeyType.sigma:
      case KeyType.bracket:
      case KeyType.openParen:
      case KeyType.closeParen: return const Color(0xFFE59400);
      case KeyType.custom:  return Colors.white54;
      case KeyType.dot:     return Colors.white;
      default:              return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasBg = _hasCircle;
    final bg = _bgColor();
    final fg = _fgColor();

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: AspectRatio(
          aspectRatio: 1,
          child: hasBg
              // ── Tombol DENGAN circle ──────────────────────────────
              ? Container(
                  decoration: BoxDecoration(
                    color: bg,
                    shape: BoxShape.circle,
                    boxShadow: bg == subjectColor
                        ? [BoxShadow(
                            color: subjectColor.withOpacity(0.35),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          )]
                        : null,
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          k.label,
                          style: TextStyle(
                            fontFamily: 'Courier',
                            // ── Ubah angka 28 untuk perbesar angka dalam circle ──
                            fontSize: k.type == KeyType.digit ? 40 : 25,
                            color: fg,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              // ── Tombol TANPA circle (operator & fn) ──────────────
              : Center(
                  child: Text(
                      k.label,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        // ── Ubah angka 26 untuk perbesar operator & fungsi ──
                        fontSize: 50,
                        color: fg,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
        ),
      );
  }
}

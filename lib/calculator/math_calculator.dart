import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'calc_widgets.dart';

class MathCalculator extends StatelessWidget {
  const MathCalculator({super.key});

  static const _color = Color(0xFF7B1E1E);

  static const _categories = [
    'Algebra',
    'Calculus',
    'Trigonometry',
    'Probability',
    'Geometry',
  ];

  static const _units = {
    'Algebra': '',
    'Calculus': '',
    'Trigonometry': '',
    'Probability': '%',
    'Geometry': '',
  };

  List<CalcKey> _specialKeys(String cat) {
    switch (cat) {
      case 'Trigonometry':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('sin', KeyType.specialFn),
          const CalcKey('cos', KeyType.specialFn),
          const CalcKey('tan', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
      case 'Calculus':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('∫', KeyType.specialFn),
          const CalcKey('^', KeyType.power),
          const CalcKey('%', KeyType.percent),
          const CalcKey('+', KeyType.opPlus),
        ];
      case 'Probability':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('n!', KeyType.specialFn),
          const CalcKey('^', KeyType.power),
          const CalcKey('%', KeyType.percent),
          const CalcKey('+', KeyType.opPlus),
        ];
      case 'Geometry':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('π', KeyType.specialFn),
          const CalcKey('^', KeyType.power),
          const CalcKey('%', KeyType.percent),
          const CalcKey('+', KeyType.opPlus),
        ];
      default: // Algebra
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('√', KeyType.sqrt_),
          const CalcKey('^', KeyType.power),
          const CalcKey('%', KeyType.percent),
          const CalcKey('+', KeyType.opPlus),
        ];
    }
  }

  String _onEqual(String category, String display, CalcEngine engine) {
    final v = double.tryParse(display);
    switch (category) {
      case 'Trigonometry__sin':
        if (v == null) return '';
        final sinRes = fmtNum(math.sin(v * math.pi / 180));
        engine.setDisplayResult(sinRes, 'sin($display°) = $sinRes');
        return sinRes;
      case 'Trigonometry__cos':
        if (v == null) return '';
        final cosRes = fmtNum(math.cos(v * math.pi / 180));
        engine.setDisplayResult(cosRes, 'cos($display°) = $cosRes');
        return cosRes;
      case 'Trigonometry__tan':
        if (v == null) return '';
        final tanRes = fmtNum(math.tan(v * math.pi / 180));
        engine.setDisplayResult(tanRes, 'tan($display°) = $tanRes');
        return tanRes;
      case 'Calculus__∫':
        // Integral of polynomial: ∫x dx = x²/2
        if (v == null) return '';
        final integralRes = fmtNum((v * v) / 2);
        engine.setDisplayResult(integralRes, '∫($display) dx = $integralRes');
        return integralRes;
      case 'Probability':
        if (v == null || v < 0 || v != v.truncateToDouble()) return '';
        // n! factorial
        int n = v.toInt();
        if (n > 20) {
          engine.setDisplayResult('Overflow', '$n! = Overflow');
          return 'Overflow';
        }
        double fact = 1;
        for (int i = 2; i <= n; i++) fact *= i;
        final res = fmtNum(fact);
        engine.setDisplayResult(res, '$n! = $res');
        return res;
      case 'Geometry__π':
        // Circle area: π × r²
        if (v == null) return '';
        final circleArea = fmtNum(math.pi * v * v);
        engine.setDisplayResult(circleArea, 'A = π×r² = π×$display² = $circleArea');
        return circleArea;
      case 'Geometry':
        // Default for Geometry: circumference = 2πr
        if (v == null) return '';
        final circumference = fmtNum(2 * math.pi * v);
        engine.setDisplayResult(circumference, 'C = 2πr = 2π×$display = $circumference');
        return circumference;
      case 'Trigonometry':
        // Default when = is pressed (no special function selected)
        return '';
      case 'Calculus':
        // Default: simple arithmetic
        return '';
      case 'Algebra':
      default:
        return ''; // Uses normal arithmetic
    }
  }

  @override
  Widget build(BuildContext context) {
    return SubjectCalculatorBase(
      subjectColor: _color,
      subjectLabel: 'Math',
      categories: _categories,
      categoryUnits: _units,
      specialKeysFor: _specialKeys,
      onEqual: _onEqual,
    );
  }
}

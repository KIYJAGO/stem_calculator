import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'calc_widgets.dart';

class StatisticCalculator extends StatelessWidget {
  const StatisticCalculator({super.key});

  static const _color = Color(0xFF6B3A1F);

  static const _categories = [
    'Descriptive',
    'Probability',
    'Regression',
    'Distribution',
    'Hypothesis',
  ];

  static const _units = {
    'Descriptive': '',
    'Probability': '%',
    'Regression': '',
    'Distribution': 'σ',
    'Hypothesis': 'p',
  };

  List<CalcKey> _specialKeys(String cat) {
    switch (cat) {
      case 'Probability':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('n!', KeyType.specialFn),
          const CalcKey('C(n,r)', KeyType.specialFn),
          const CalcKey('P(n,r)', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
      case 'Distribution':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('σ', KeyType.specialFn),
          const CalcKey('Z-score', KeyType.specialFn),
          const CalcKey('variance', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
      case 'Regression':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('r²', KeyType.specialFn),
          const CalcKey('r', KeyType.specialFn),
          const CalcKey('log', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
      case 'Hypothesis':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('z', KeyType.specialFn),
          const CalcKey('t-test', KeyType.specialFn),
          const CalcKey('p-value', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
      default: // Descriptive
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('√σ', KeyType.sqrt_),
          const CalcKey('Σ', KeyType.sigma),
          const CalcKey('Mean', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
    }
  }

  String _onEqual(String category, String display, CalcEngine engine) {
    final v = double.tryParse(display);
    switch (category) {
      case 'Descriptive__Mean':
        // Mean = sum of all values / count (display = single value)
        if (v == null) return '';
        // For single value, mean = value itself
        engine.setDisplayResult(display, 'Mean = $display');
        return display;
      case 'Descriptive':
        // Default: calculate standard deviation for the value
        if (v == null) return '';
        final stdDev = fmtNum(math.sqrt(v));
        engine.setDisplayResult(stdDev, 'σ = √$display = $stdDev');
        return stdDev;
      case 'Probability__n!':
        // n! factorial
        if (v == null || v < 0 || v != v.truncateToDouble()) return '';
        final n = v.toInt();
        if (n > 20) {
          engine.setDisplayResult('Overflow', '$n! = Overflow');
          return 'Overflow';
        }
        double fact = 1;
        for (int i = 2; i <= n; i++) fact *= i;
        final res = fmtNum(fact);
        engine.setDisplayResult(res, '$n! = $res');
        return res;
      case 'Probability__C(n,r)':
        // Combination C(n,r) = n! / (r!(n-r)!) - assume r = 2
        if (v == null || v < 2) return '';
        final n = v.toInt();
        final r = 2;
        double nFact = 1, rFact = 1, nrFact = 1;
        for (int i = 2; i <= n; i++) nFact *= i;
        for (int i = 2; i <= r; i++) rFact *= i;
        for (int i = 2; i <= (n - r); i++) nrFact *= i;
        final combination = fmtNum(nFact / (rFact * nrFact));
        engine.setDisplayResult(combination, 'C($n,$r) = $combination');
        return combination;
      case 'Probability__P(n,r)':
        // Permutation P(n,r) = n! / (n-r)! - assume r = 2
        if (v == null || v < 2) return '';
        final n = v.toInt();
        final r = 2;
        double nFact = 1, nrFact = 1;
        for (int i = 2; i <= n; i++) nFact *= i;
        for (int i = 2; i <= (n - r); i++) nrFact *= i;
        final permutation = fmtNum(nFact / nrFact);
        engine.setDisplayResult(permutation, 'P($n,$r) = $permutation');
        return permutation;
      case 'Probability':
        return '';
      case 'Distribution__σ':
        // Standard deviation = sqrt(variance)
        if (v == null) return '';
        final stdDev = fmtNum(math.sqrt(v));
        engine.setDisplayResult(stdDev, 'σ = √$display = $stdDev');
        return stdDev;
      case 'Distribution__Z-score':
        // Z-score = (x - μ) / σ; display = (x - μ), assume σ = 1
        if (v == null) return '';
        final zScore = fmtNum(v / 1);
        engine.setDisplayResult(zScore, 'Z = $display / σ = $zScore');
        return zScore;
      case 'Distribution__variance':
        // Variance = σ²; display = σ
        if (v == null) return '';
        final variance = fmtNum(v * v);
        engine.setDisplayResult(variance, 'σ² = ($display)² = $variance');
        return variance;
      case 'Distribution':
        return '';
      case 'Regression__r²':
        // Coefficient of determination r² = r * r; display = r
        if (v == null) return '';
        final r2 = fmtNum(v * v);
        engine.setDisplayResult(r2, 'r² = ($display)² = $r2');
        return r2;
      case 'Regression__r':
        // Correlation coefficient r (display = r value)
        if (v == null || v < -1 || v > 1) return '';
        engine.setDisplayResult(display, 'r = $display');
        return display;
      case 'Regression':
        return '';
      case 'Hypothesis__z':
        // Z-test statistic
        if (v == null) return '';
        final pValue = fmtNum(2 * (1 - _normCdf(v.abs())));
        engine.setDisplayResult(pValue, 'p-value(z=$display) ≈ $pValue');
        return pValue;
      case 'Hypothesis__t-test':
        // Simple t-statistic calculation (display = t value)
        if (v == null) return '';
        final p = fmtNum(
          2 * (1 - _normCdf(v.abs())),
        ); // Approximate using normal
        engine.setDisplayResult(p, 'p-value(t=$display) ≈ $p');
        return p;
      case 'Hypothesis__p-value':
        // Calculate p-value from z-score or similar
        if (v == null) return '';
        final p = fmtNum(2 * (1 - _normCdf(v.abs())));
        engine.setDisplayResult(p, 'p-value ≈ $p');
        return p;
      case 'Hypothesis':
        // Default: p-value approximation from z
        if (v == null) return '';
        final p = fmtNum(2 * (1 - _normCdf(v.abs())));
        engine.setDisplayResult(p, 'p(z=$display) ≈ $p');
        return p;
      default:
        return '';
    }
  }

  // Approximation of normal CDF
  double _normCdf(double x) {
    const a1 = 0.254829592, a2 = -0.284496736, a3 = 1.421413741;
    const a4 = -1.453152027, a5 = 1.061405429, p = 0.3275911;
    final t = 1 / (1 + p * x);
    final y =
        1 -
        (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) *
            t *
            math.exp(-x * x / 2);
    return y;
  }

  @override
  Widget build(BuildContext context) {
    return SubjectCalculatorBase(
      subjectColor: _color,
      subjectLabel: 'Statistic',
      categories: _categories,
      categoryUnits: _units,
      specialKeysFor: _specialKeys,
      onEqual: _onEqual,
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'calc_widgets.dart';

class BiologyCalculator extends StatelessWidget {
  const BiologyCalculator({super.key});

  static const _color = Color(0xFF2D5A27);

  static const _categories = [
    'Cell',
    'Genetics',
    'Ecology',
    'Molecular',
    'Physiology',
  ];

  static const _units = {
    'Cell': 'μm',
    'Genetics': '',
    'Ecology': '',
    'Molecular': 'Mol',
    'Physiology': 'bpm',
  };

  List<CalcKey> _specialKeys(String cat) {
    switch (cat) {
      case 'Genetics':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('p²', KeyType.specialFn),
          const CalcKey('2pq', KeyType.specialFn),
          const CalcKey('q²', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
      case 'Ecology':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('ln(N)', KeyType.specialFn),
          const CalcKey('λ', KeyType.specialFn),
          const CalcKey('growth', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
      case 'Molecular':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('NA', KeyType.specialFn), // Avogadro's number
          const CalcKey('mol', KeyType.specialFn),
          const CalcKey('atoms', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
      case 'Physiology':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('MaxHR', KeyType.specialFn),
          const CalcKey('BMI', KeyType.specialFn),
          const CalcKey('VO2', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
      default: // Cell
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('SA', KeyType.specialFn),
          const CalcKey('Vol', KeyType.specialFn),
          const CalcKey('Diam', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
    }
  }

  String _onEqual(String category, String display, CalcEngine engine) {
    final v = double.tryParse(display);
    switch (category) {
      case 'Cell__SA':
        // Surface area of sphere (cell model): 4πr²
        if (v == null) return '';
        final surfaceArea = fmtNum(4 * math.pi * v * v);
        engine.setDisplayResult(
          surfaceArea,
          'SA = 4πr² = 4π×($display)² = $surfaceArea μm²',
        );
        return surfaceArea;
      case 'Cell__Vol':
        // Volume of sphere: (4/3)πr³
        if (v == null) return '';
        final volume = fmtNum((4 / 3) * math.pi * v * v * v);
        engine.setDisplayResult(volume, 'V = (4/3)πr³ = $volume μm³');
        return volume;
      case 'Cell__Diam':
        // Diameter = 2r (display = radius)
        if (v == null) return '';
        final diameter = fmtNum(2 * v);
        engine.setDisplayResult(diameter, 'D = 2r = 2×$display = $diameter μm');
        return diameter;
      case 'Cell':
        // Default: same as Surface Area
        if (v == null) return '';
        final surfaceArea = fmtNum(4 * math.pi * v * v);
        engine.setDisplayResult(surfaceArea, 'SA = 4πr² = $surfaceArea μm²');
        return surfaceArea;
      case 'Genetics__p²':
        // Hardy-Weinberg: homozygous dominant frequency (p²)
        if (v == null) return '';
        final p2 = fmtNum(v * v);
        engine.setDisplayResult(p2, 'p² = ($display)² = $p2');
        return p2;
      case 'Genetics__2pq':
        // Hardy-Weinberg: heterozygous frequency (2pq), assume q = 1-p
        if (v == null || v < 0 || v > 1) return '';
        final q = 1 - v;
        final pq2 = fmtNum(2 * v * q);
        engine.setDisplayResult(pq2, '2pq = 2×$display×${fmtNum(q)} = $pq2');
        return pq2;
      case 'Genetics__q²':
        // Hardy-Weinberg: homozygous recessive (q²), assume q = 1-p
        if (v == null || v < 0 || v > 1) return '';
        final q = 1 - v;
        final q2 = fmtNum(q * q);
        engine.setDisplayResult(q2, 'q² = ${fmtNum(q)}² = $q2');
        return q2;
      case 'Genetics':
        return '';
      case 'Ecology__ln(N)':
        // Natural log of population size
        if (v == null || v <= 0) return '';
        final lnN = fmtNum(math.log(v));
        engine.setDisplayResult(lnN, 'ln($display) = $lnN');
        return lnN;
      case 'Ecology__λ':
        // Finite rate of increase (lambda) = N(t+1)/N(t)
        // Assuming display = N(t+1), assume N(t) = 1
        if (v == null) return '';
        final lambda = fmtNum(v / 1);
        engine.setDisplayResult(lambda, 'λ = N(t+1)/N(t) = $display');
        return lambda;
      case 'Ecology__growth':
        // Exponential growth rate (r): N = N₀e^(rt)
        if (v == null) return '';
        final growth = fmtNum(math.log(v)); // ln(N/N₀)
        engine.setDisplayResult(growth, 'r ≈ ln($display)');
        return growth;
      case 'Ecology':
        // Default: natural log
        if (v == null || v <= 0) return '';
        final lnN = fmtNum(math.log(v));
        engine.setDisplayResult(lnN, 'ln($display) = $lnN');
        return lnN;
      case 'Molecular__NA':
        // Number of atoms/molecules = moles × Avogadro's number
        // display = moles
        if (v == null) return '';
        const double avogadro = 6.022e23;
        final atoms = fmtNum(v * avogadro);
        engine.setDisplayResult(atoms, 'N = n × Nₐ = $display × 6.022e23');
        return atoms;
      case 'Molecular__mol':
        // Moles from number of particles = N / Avogadro
        if (v == null) return '';
        const double avogadro = 6.022e23;
        final moles = fmtNum(v / avogadro);
        engine.setDisplayResult(
          moles,
          'n = N / Nₐ = $display / 6.022e23 = $moles mol',
        );
        return moles;
      case 'Molecular__atoms':
        // Number of atoms = moles × atoms per molecule
        // For compound like H₂O: 3 atoms per molecule
        if (v == null) return '';
        const int atomsPerMol = 3; // Example for H₂O
        final totalAtoms = fmtNum(v * atomsPerMol);
        engine.setDisplayResult(
          totalAtoms,
          'Total atoms = $display mol × $atomsPerMol = $totalAtoms',
        );
        return totalAtoms;
      case 'Molecular':
        // Default: moles calculation
        if (v == null) return '';
        const double avogadro = 6.022e23;
        final atoms = fmtNum(v * avogadro);
        engine.setDisplayResult(atoms, 'N = $display × Nₐ = $atoms');
        return atoms;
      case 'Physiology__MaxHR':
        // Max heart rate = 220 - age
        if (v == null) return '';
        final maxHR = fmtNum(220 - v);
        engine.setDisplayResult(maxHR, 'MaxHR = 220 - $display = $maxHR bpm');
        return maxHR;
      case 'Physiology__BMI':
        // BMI = weight(kg) / height²(m²)
        // display = weight, assume height = 1.75m
        if (v == null) return '';
        const double height = 1.75;
        final bmi = fmtNum(v / (height * height));
        engine.setDisplayResult(
          bmi,
          'BMI = $display / ${fmtNum(height * height)} = $bmi',
        );
        return bmi;
      case 'Physiology__VO2':
        // VO2 max estimation: roughly proportional to heart rate reserve
        if (v == null) return '';
        final vo2 = fmtNum(v * 0.15); // Very rough approximation
        engine.setDisplayResult(vo2, 'VO₂ ≈ $display × 0.15 = $vo2 mL/kg/min');
        return vo2;
      case 'Physiology':
        // Default: Max heart rate
        if (v == null) return '';
        final maxHR = fmtNum(220 - v);
        engine.setDisplayResult(maxHR, 'MaxHR = 220 - $display = $maxHR bpm');
        return maxHR;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SubjectCalculatorBase(
      subjectColor: _color,
      subjectLabel: 'Biology',
      categories: _categories,
      categoryUnits: _units,
      specialKeysFor: _specialKeys,
      onEqual: _onEqual,
    );
  }
}

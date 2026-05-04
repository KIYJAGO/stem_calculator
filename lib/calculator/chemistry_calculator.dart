import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'calc_widgets.dart';

class ChemistryCalculator extends StatelessWidget {
  const ChemistryCalculator({super.key});

  static const _color = Color(0xFF5B2D8E);

  static const _categories = [
    'Stoichiometry',
    'Thermochemistry',
    'Acids/Bases',
    'Electrochemistry',
    'Gases',
  ];

  static const _units = {
    'Stoichiometry': 'mol',
    'Thermochemistry': 'kJ',
    'Acids/Bases': 'pH',
    'Electrochemistry': 'V',
    'Gases': 'L',
  };

  List<CalcKey> _specialKeys(String cat) {
    switch (cat) {
      case 'Acids/Bases':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('pH', KeyType.specialFn),
          const CalcKey('pOH', KeyType.specialFn),
          const CalcKey('log', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
      case 'Thermochemistry':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('ΔH', KeyType.specialFn),
          const CalcKey('ΔS', KeyType.specialFn),
          const CalcKey('ΔG', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
      case 'Electrochemistry':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('E°', KeyType.specialFn),
          const CalcKey('ΔG', KeyType.specialFn),
          const CalcKey('log', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
      case 'Gases':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('PV', KeyType.specialFn),
          const CalcKey('nRT', KeyType.specialFn),
          const CalcKey('log', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
      default: // Stoichiometry
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('mol', KeyType.specialFn),
          const CalcKey('^', KeyType.power),
          const CalcKey('log', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
    }
  }

  String _onEqual(String category, String display, CalcEngine engine) {
    final v = double.tryParse(display);
    switch (category) {
      case 'Acids/Bases__pH':
        // pH = -log10([H+])
        if (v == null || v <= 0) return '';
        final pH = fmtNum(-math.log(v) / math.ln10);
        engine.setDisplayResult(pH, 'pH = -log10($display) = $pH');
        return pH;
      case 'Acids/Bases':
        // Default: calculate pOH = 14 - pH
        if (v == null || v < 0 || v > 14) return '';
        final pOH = fmtNum(14 - v);
        engine.setDisplayResult(pOH, 'pOH = 14 - pH = 14 - $display = $pOH');
        return pOH;
      case 'Thermochemistry__ΔH':
        // ΔG = ΔH - TΔS (assume T=298K, ΔS=0.1 kJ/K as default)
        if (v == null) return '';
        const double T = 298; // Kelvin
        const double deltaS = 0.1; // kJ/K (example)
        final deltaG = fmtNum(v - (T * deltaS));
        engine.setDisplayResult(
          deltaG,
          'ΔG = ΔH - TΔS = $display - (298×0.1) = $deltaG kJ',
        );
        return deltaG;
      case 'Thermochemistry':
        // Enthalpy change calculation (basic)
        return '';
      case 'Electrochemistry__E°':
        // Cell potential: ΔG = -nFE (assume n=1, F=96485 C/mol)
        if (v == null) return '';
        const double n = 1;
        const double F = 96485; // Faraday's constant
        final deltaG = fmtNum(-n * F * v / 1000); // kJ
        engine.setDisplayResult(
          deltaG,
          'ΔG = -nFE = -(1)(96485)($display) = $deltaG kJ',
        );
        return deltaG;
      case 'Electrochemistry':
        return '';
      case 'Gases__PV':
        // Ideal Gas Law rearranged: PV = nRT → V = nRT/P
        if (v == null || v == 0) return ''; // v = P (pressure)
        const R = 0.08206; // L·atm/(mol·K)
        const T = 298.0; // K (25°C)
        const n = 1.0; // 1 mole
        final V = fmtNum(n * R * T / v);
        engine.setDisplayResult(
          V,
          'V = nRT/P = (1)(0.08206)(298)/$display = $V L',
        );
        return V;
      case 'Gases':
        // Default for gases
        return '';
      case 'Stoichiometry':
        // Moles = mass / molar mass (assuming input is mass in grams, common molar mass ~18 g/mol)
        if (v == null) return '';
        const averageMolarMass = 18.0; // Example: water
        final moles = fmtNum(v / averageMolarMass);
        engine.setDisplayResult(
          moles,
          'n = m/M = $display g / $averageMolarMass g/mol = $moles mol',
        );
        return moles;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SubjectCalculatorBase(
      subjectColor: _color,
      subjectLabel: 'Chemistry',
      categories: _categories,
      categoryUnits: _units,
      specialKeysFor: _specialKeys,
      onEqual: _onEqual,
    );
  }
}

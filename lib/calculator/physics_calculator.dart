import 'package:flutter/material.dart';
import 'calc_widgets.dart';

class PhysicsCalculator extends StatelessWidget {
  const PhysicsCalculator({super.key});

  static const _color = Color(0xFF1A3A5C);

  static const _categories = [
    'Mechanics',
    'Thermodynamics',
    'Electricity',
    'Waves',
    'Optics',
  ];

  static const _units = {
    'Mechanics': 'N',
    'Thermodynamics': '°C',
    'Electricity': 'A',
    'Waves': 'Hz',
    'Optics': 'm',
  };

  List<CalcKey> _specialKeys(String cat) {
    switch (cat) {
      case 'Thermodynamics':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('°F→C', KeyType.specialFn),
          const CalcKey('°C→F', KeyType.specialFn),
          const CalcKey('K→C', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
      case 'Electricity':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('P=VI', KeyType.specialFn),
          const CalcKey('R=V/I', KeyType.specialFn),
          const CalcKey('I=V/R', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
      case 'Waves':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('f=v/λ', KeyType.specialFn),
          const CalcKey('λ=v/f', KeyType.specialFn),
          const CalcKey('v=fλ', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
      case 'Optics':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('n=c/v', KeyType.specialFn),
          const CalcKey('1/f', KeyType.specialFn),
          const CalcKey('^', KeyType.power),
          const CalcKey('+', KeyType.opPlus),
        ];
      default: // Mechanics
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('F=ma', KeyType.specialFn),
          const CalcKey('a=v/t', KeyType.specialFn),
          const CalcKey('KE=½mv²', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
    }
  }

  String _onEqual(String category, String display, CalcEngine engine) {
    final v = double.tryParse(display);
    switch (category) {
      case 'Mechanics__F=ma':
        // F = m × a (display = mass, assume a = 10 m/s²)
        if (v == null) return '';
        const double a = 10.0; // m/s²
        final force = fmtNum(v * a);
        engine.setDisplayResult(force, 'F = m×a = $display × $a = $force N');
        return force;
      case 'Mechanics__a=v/t':
        // Acceleration = velocity / time (display = velocity, assume t = 1 second)
        if (v == null) return '';
        const double t = 1.0;
        final acceleration = fmtNum(v / t);
        engine.setDisplayResult(
          acceleration,
          'a = v/t = $display / $t = $acceleration m/s²',
        );
        return acceleration;
      case 'Mechanics__KE=½mv²':
        // Kinetic energy = 0.5 × m × v² (display = v, assume m = 1 kg)
        if (v == null) return '';
        const double m = 1.0;
        final ke = fmtNum(0.5 * m * v * v);
        engine.setDisplayResult(ke, 'KE = ½mv² = 0.5 × $m × $display² = $ke J');
        return ke;
      case 'Mechanics':
        return '';
      case 'Thermodynamics__°F→C':
        // Fahrenheit to Celsius
        if (v == null) return '';
        final celsius = fmtNum((v - 32) * 5 / 9);
        engine.setDisplayResult(celsius, '${display}°F → ${celsius}°C');
        return celsius;
      case 'Thermodynamics__°C→F':
        // Celsius to Fahrenheit
        if (v == null) return '';
        final fahrenheit = fmtNum((v * 9 / 5) + 32);
        engine.setDisplayResult(fahrenheit, '${display}°C → ${fahrenheit}°F');
        return fahrenheit;
      case 'Thermodynamics__K→C':
        // Kelvin to Celsius
        if (v == null) return '';
        final celsius = fmtNum(v - 273.15);
        engine.setDisplayResult(celsius, '${display}K → ${celsius}°C');
        return celsius;
      case 'Thermodynamics':
        return '';
      case 'Electricity__P=VI':
        // Power = Voltage × Current (display = voltage, assume I = 1 A)
        if (v == null) return '';
        const double I = 1.0;
        final power = fmtNum(v * I);
        engine.setDisplayResult(power, 'P = V×I = $display × $I = $power W');
        return power;
      case 'Electricity__R=V/I':
        // Resistance = Voltage / Current (display = voltage, assume I = 1 A)
        if (v == null || v == 0) return '';
        const double I = 1.0;
        final resistance = fmtNum(v / I);
        engine.setDisplayResult(
          resistance,
          'R = V/I = $display / $I = $resistance Ω',
        );
        return resistance;
      case 'Electricity__I=V/R':
        // Current = Voltage / Resistance (display = voltage, assume R = 10 Ω)
        if (v == null) return '';
        const double R = 10.0;
        final current = fmtNum(v / R);
        engine.setDisplayResult(
          current,
          'I = V/R = $display / $R = $current A',
        );
        return current;
      case 'Electricity':
        return '';
      case 'Waves__f=v/λ':
        // Frequency = velocity / wavelength (display = wavelength, v = 340 m/s)
        if (v == null || v == 0) return '';
        final frequency = fmtNum(340 / v);
        engine.setDisplayResult(
          frequency,
          'f = v/λ = 340 / $display = ${frequency} Hz',
        );
        return frequency;
      case 'Waves__λ=v/f':
        // Wavelength = velocity / frequency (display = frequency, v = 340 m/s)
        if (v == null || v == 0) return '';
        final wavelength = fmtNum(340 / v);
        engine.setDisplayResult(
          wavelength,
          'λ = v/f = 340 / $display = ${wavelength} m',
        );
        return wavelength;
      case 'Waves__v=fλ':
        // Velocity = frequency × wavelength (display = frequency, assume λ = 1 m)
        if (v == null) return '';
        const double lambda = 1.0;
        final velocity = fmtNum(v * lambda);
        engine.setDisplayResult(
          velocity,
          'v = f×λ = $display × $lambda = ${velocity} m/s',
        );
        return velocity;
      case 'Waves':
        return '';
      case 'Optics__n=c/v':
        // Refractive index = speed of light / speed in medium (display = v)
        if (v == null || v == 0) return '';
        final refIndex = fmtNum(299792458 / v);
        engine.setDisplayResult(
          refIndex,
          'n = c/v = 299792458 / $display = $refIndex',
        );
        return refIndex;
      case 'Optics__1/f':
        // Lens power (diopters) = 1 / focal length (display = focal length in meters)
        if (v == null || v == 0) return '';
        final power = fmtNum(1 / v);
        engine.setDisplayResult(power, 'P = 1/f = 1 / $display = $power D');
        return power;
      case 'Optics':
        return '';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SubjectCalculatorBase(
      subjectColor: _color,
      subjectLabel: 'Physics',
      categories: _categories,
      categoryUnits: _units,
      specialKeysFor: _specialKeys,
      onEqual: _onEqual,
    );
  }
}

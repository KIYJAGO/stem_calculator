import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'calc_widgets.dart';

class ComputingCalculator extends StatelessWidget {
  const ComputingCalculator({super.key});

  static const _color = Color(0xFF6B7A1F);

  static const _categories = [
    'Binary',
    'Data Size',
    'Networking',
    'Algorithm',
    'Logic',
  ];

  static const _units = {
    'Binary': 'bin',
    'Data Size': 'Byte',
    'Networking': 'Mbps',
    'Algorithm': 'O(n)',
    'Logic': '',
  };

  List<CalcKey> _specialKeys(String cat) {
    switch (cat) {
      case 'Binary':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('Dec→Bin', KeyType.specialFn),
          const CalcKey('Bin→Dec', KeyType.specialFn),
          const CalcKey('Hex', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
      case 'Data Size':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('→KB', KeyType.specialFn),
          const CalcKey('→MB', KeyType.specialFn),
          const CalcKey('→GB', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
      case 'Networking':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('Download', KeyType.specialFn),
          const CalcKey('Speed', KeyType.specialFn),
          const CalcKey('Upload', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
      case 'Algorithm':
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('log₂', KeyType.specialFn),
          const CalcKey('log₁₀', KeyType.specialFn),
          const CalcKey('n log n', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
      default: // Logic
        return [
          const CalcKey('C', KeyType.clear),
          const CalcKey('AND', KeyType.specialFn),
          const CalcKey('OR', KeyType.specialFn),
          const CalcKey('XOR', KeyType.specialFn),
          const CalcKey('+', KeyType.opPlus),
        ];
    }
  }

  String _onEqual(String category, String display, CalcEngine engine) {
    final v = double.tryParse(display);
    switch (category) {
      case 'Binary__Dec→Bin':
        // Decimal to binary
        if (v == null || v < 0) return '';
        final bin = v.toInt().toRadixString(2);
        engine.setDisplayResult(bin, '$display₁₀ = $bin₂');
        return bin;
      case 'Binary__Bin→Dec':
        // Binary to decimal (interpret display as binary)
        try {
          if (display.isEmpty) return '';
          final dec = int.parse(display, radix: 2);
          final result = fmtNum(dec.toDouble());
          engine.setDisplayResult(result, '$display₂ = $result₁₀');
          return result;
        } catch (e) {
          engine.setDisplayResult('Error', 'Invalid binary number');
          return 'Error';
        }
      case 'Binary__Hex':
        // Decimal to hexadecimal
        if (v == null || v < 0) return '';
        final hex = v.toInt().toRadixString(16).toUpperCase();
        engine.setDisplayResult(hex, '$display₁₀ = 0x$hex');
        return hex;
      case 'Binary':
        // Default: decimal to binary
        if (v == null || v < 0) return '';
        final bin = v.toInt().toRadixString(2);
        engine.setDisplayResult(bin, '$display → $bin (binary)');
        return bin;
      case 'Data Size→KB':
        // Bytes to Kilobytes
        if (v == null) return '';
        final kb = fmtNum(v / 1024);
        engine.setDisplayResult(kb, '$display B = $kb KB');
        return kb;
      case 'Data Size→MB':
        // Bytes to Megabytes
        if (v == null) return '';
        final mb = fmtNum(v / (1024 * 1024));
        engine.setDisplayResult(mb, '$display B = $mb MB');
        return mb;
      case 'Data Size→GB':
        // Bytes to Gigabytes
        if (v == null) return '';
        final gb = fmtNum(v / (1024 * 1024 * 1024));
        engine.setDisplayResult(gb, '$display B = $gb GB');
        return gb;
      case 'Data Size':
        // Default: Bytes to KB
        if (v == null) return '';
        final kb = fmtNum(v / 1024);
        engine.setDisplayResult(kb, '$display B = $kb KB');
        return kb;
      case 'Networking__Download':
        // Download time (s) = file size (MB) / speed (Mbps) × 8
        // display = file size in MB, assume 100 Mbps
        if (v == null || v == 0) return '';
        const speed = 100.0; // Mbps
        final secs = fmtNum((v * 8) / speed);
        engine.setDisplayResult(secs, '${display}MB @${speed}Mbps = ${secs}s');
        return secs;
      case 'Networking__Speed':
        // Download speed calculation (Mbps) = (file size MB × 8) / time(s)
        if (v == null || v == 0) return '';
        // display = time in seconds, assume 100 MB file
        const fileSize = 100.0;
        final speed = fmtNum((fileSize * 8) / v);
        engine.setDisplayResult(
          speed,
          'Speed = (${fileSize}MB × 8) / ${display}s = ${speed} Mbps',
        );
        return speed;
      case 'Networking__Upload':
        // Upload time similar to download
        if (v == null || v == 0) return '';
        const speed = 50.0; // Typical upload speed
        final secs = fmtNum((v * 8) / speed);
        engine.setDisplayResult(secs, '${display}MB @${speed}Mbps = ${secs}s');
        return secs;
      case 'Networking':
        // Default: download time
        if (v == null || v == 0) return '';
        const speed = 100.0;
        final secs = fmtNum((v * 8) / speed);
        engine.setDisplayResult(secs, '${display}MB = ${secs}s');
        return secs;
      case 'Algorithm__log₂':
        // Log base 2
        if (v == null || v <= 0) return '';
        final log2 = fmtNum(math.log(v) / math.log(2));
        engine.setDisplayResult(log2, 'log₂($display) = $log2');
        return log2;
      case 'Algorithm__log₁₀':
        // Log base 10
        if (v == null || v <= 0) return '';
        final log10 = fmtNum(math.log(v) / math.log(10));
        engine.setDisplayResult(log10, 'log₁₀($display) = $log10');
        return log10;
      case 'Algorithm__n log n':
        // N log N complexity indicator
        if (v == null || v <= 0) return '';
        final nlogn = fmtNum(v * (math.log(v) / math.log(2)));
        engine.setDisplayResult(nlogn, '$display × log₂($display) = $nlogn');
        return nlogn;
      case 'Algorithm':
        // Default: log base 2
        if (v == null || v <= 0) return '';
        final log2 = fmtNum(math.log(v) / math.log(2));
        engine.setDisplayResult(log2, 'log₂($display) = $log2');
        return log2;
      case 'Logic__AND':
        // Bitwise AND (for integers)
        if (v == null) return '';
        final int intVal = v.toInt();
        const int mask = 255; // 8-bit AND with 255
        final result = fmtNum((intVal & mask).toDouble());
        engine.setDisplayResult(result, '$intVal AND $mask = $result');
        return result;
      case 'Logic__OR':
        // Bitwise OR
        if (v == null) return '';
        final int intVal = v.toInt();
        const int mask = 1;
        final result = fmtNum((intVal | mask).toDouble());
        engine.setDisplayResult(result, '$intVal OR $mask = $result');
        return result;
      case 'Logic__XOR':
        // Bitwise XOR
        if (v == null) return '';
        final int intVal = v.toInt();
        const int mask = 1;
        final result = fmtNum((intVal ^ mask).toDouble());
        engine.setDisplayResult(result, '$intVal XOR $mask = $result');
        return result;
      case 'Logic':
        // Default: NOT operation
        if (v == null) return '';
        final result = (~v.toInt()).toString();
        engine.setDisplayResult(result, 'NOT $display = $result');
        return result;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SubjectCalculatorBase(
      subjectColor: _color,
      subjectLabel: 'Computing',
      categories: _categories,
      categoryUnits: _units,
      specialKeysFor: _specialKeys,
      onEqual: _onEqual,
    );
  }
}

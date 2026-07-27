import 'package:flutter/material.dart';
import 'math_calculator.dart';
import 'physics_calculator.dart';
import 'biology_calculator.dart';
import 'chemistry_calculator.dart';
import 'statistic_calculator.dart';
import 'computing_calculator.dart';

class BaseCalculatorScreen extends StatelessWidget {
  final dynamic card; // SubjectCard

  const BaseCalculatorScreen({super.key, required this.card});

  Widget _buildBody() {
    switch (card.id) {
      case 'math':
        return MathCalculator();
      case 'physics':
        return PhysicsCalculator();
      case 'biology':
        return BiologyCalculator();
      case 'chemistry':
        return ChemistryCalculator();
      case 'statistic':
        return StatisticCalculator();
      case 'computing':
        return ComputingCalculator();
      default:
        return const Center(
          child: Text(
            'Coming Soon',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Courier',
              fontSize: 16,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          card.label,
          style: const TextStyle(
            fontFamily: 'Courier',
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }
}
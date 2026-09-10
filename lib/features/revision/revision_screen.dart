import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class RevisionScreen extends StatelessWidget {
  const RevisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeepLight,
      body: const Center(child: Text('Révision')),
    );
  }
}

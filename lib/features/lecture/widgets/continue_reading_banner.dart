import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/sourate.dart';

class ContinueReadingBanner extends StatelessWidget {
  final Sourate sourate;
  final int dernierVerset;
  final VoidCallback onTap;
  final bool isDarkMode;

  const ContinueReadingBanner({
    super.key,
    required this.sourate,
    required this.dernierVerset,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDarkMode ? AppColors.bgSurface : AppColors.bgSurfaceLight;
    final text = isDarkMode ? AppColors.cream : AppColors.creamLight;
    final textSecondary = isDarkMode ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final accent = isDarkMode ? AppColors.gold : AppColors.goldLight;
    final line = isDarkMode ? AppColors.line : AppColors.lineLight;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: line),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Continuer la lecture',
                      style: TextStyle(color: text, fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dernier lu : ${sourate.nom}, verset $dernierVerset',
                      style: TextStyle(color: textSecondary, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: accent.withOpacity(0.15), shape: BoxShape.circle),
                child: Icon(Icons.play_arrow, color: accent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



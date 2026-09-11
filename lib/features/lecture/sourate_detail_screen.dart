import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/theme_provider.dart';
import '../../data/models/sourate.dart';
import '../../data/models/page_coran.dart';
import '../../data/repositories/quran_repository.dart';

class SourateDetailScreen extends StatefulWidget {
  final Sourate sourate;

  const SourateDetailScreen({super.key, required this.sourate});

  @override
  State<SourateDetailScreen> createState() => _SourateDetailScreenState();
}

class _SourateDetailScreenState extends State<SourateDetailScreen> {
  bool _isBarVisible = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() => _isBarVisible = false);
    });
  }

  void _handleScreenTap() {
    setState(() => _isBarVisible = true);
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.bgDeepFor(isDarkMode),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _handleScreenTap,
        child: Stack(
          children: [
            // ---- Contenu de la sourate (placeholder pour l'instant) ----
            SafeArea(
              child: FutureBuilder<PageCoran>(
                future: Future(() => QuranRepository().getPage(
                      QuranRepository().getFirstPageOfSourate(widget.sourate.numero),
                    )),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final page = snapshot.data!;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      page.versets.map((v) => '(${v.sourateNumero}:${v.numero}) ${v.texte}').join('\n\n'),
                      style: const TextStyle(fontFamily: 'serif', fontSize: 20),
                      textDirection: TextDirection.rtl,
                    ),
                  );
                },
              ),          
            ),

            // ---- AppBar flottante, colorée dès le tout haut de l'écran ----
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _isBarVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 100),
                child: IgnorePointer(
                  ignoring: !_isBarVisible,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(8, statusBarHeight + 8, 8, 15),
                    decoration: BoxDecoration(
                      color: AppColors.goldFor(isDarkMode),
                      // borderRadius: const BorderRadius.only(
                      //   bottomLeft: Radius.circular(18),
                      //   bottomRight: Radius.circular(18),
                      // ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.sourate.nom,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                widget.sourate.nomArabe,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontFamily: 'serif',
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => context.read<ThemeProvider>().toggleTheme(),
                          icon: Icon(
                            isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
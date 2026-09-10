import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/surah_number_badge.dart';
import '../../data/models/sourate.dart';
import '../../data/repositories/quran_repository.dart';
import 'widgets/continue_reading_banner.dart';

class LectureScreen extends StatefulWidget {
  const LectureScreen({super.key});

  @override
  State<LectureScreen> createState() => _LectureScreenState();
}

class _LectureScreenState extends State<LectureScreen> {
  final QuranRepository _repository = QuranRepository();
  final _searchController = TextEditingController();
  String _search = '';
  bool _isDarkMode = false;

  List<Sourate> _sourates = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSourates();
  }

  Future<void> _loadSourates() async {
    final sourates = await _repository.getAllSourates();
    setState(() {
      _sourates = sourates;
      _isLoading = false;
    });
  }

  List<Sourate> get _filteredSourates {
    final query = _search.trim().toLowerCase();
    if (query.isEmpty) return _sourates;
    return _sourates.where((s) {
      return s.nom.toLowerCase().contains(query) ||
          s.traduction.toLowerCase().contains(query) ||
          s.nomArabe.contains(query) ||
          s.numero.toString() == query;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ---- Couleurs dynamiques selon le mode ----
  Color get _bgDeep => _isDarkMode ? AppColors.bgDeep : AppColors.bgDeepLight;
  Color get _bgSurface => _isDarkMode ? AppColors.bgSurface : AppColors.bgSurfaceLight;
  Color get _accent => _isDarkMode ? AppColors.gold : AppColors.goldLight;
  Color get _accentSoft => _isDarkMode ? AppColors.goldSoft : AppColors.goldSoftLight;
  Color get _text => _isDarkMode ? AppColors.cream : AppColors.creamLight;
  Color get _textSecondary => _isDarkMode ? AppColors.textSecondary : AppColors.textSecondaryLight;
  Color get _line => _isDarkMode ? AppColors.line : AppColors.lineLight;
  Color get _creamDim => _isDarkMode ? AppColors.creamDim : AppColors.creamDimLight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDeep,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildHeaderWithBanner(),
                  const SizedBox(height: 46),
                  Expanded(child: _buildSourateList()),
                ],
              ),
      ),
    );
  }

  Widget _buildHeaderWithBanner() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 70),
          decoration: BoxDecoration(
            color: _accent,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // const Text(
                  //   'Lecture du Coran',
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.w700,
                  //   ),
                  // ),
                  Row(
                    children: [
                      _HeaderButton(
                        icon: _isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                        onTap: () => setState(() => _isDarkMode = !_isDarkMode),
                      ),
                      const SizedBox(width: 8),
                      _HeaderButton(label: 'FR', onTap: () {}),
                      const SizedBox(width: 5),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 54,
                decoration: BoxDecoration(
                  color: _bgRaised(),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _search = value),
                  style: TextStyle(color: _text, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Rechercher une sourate',
                    hintStyle: TextStyle(color: _textSecondary),
                    prefixIcon: Icon(Icons.search, color: _accentSoft),
                    suffixIcon: _search.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _search = '');
                            },
                            icon: const Icon(Icons.close, size: 18),
                            color: _accentSoft,
                          ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_search.isEmpty)
          Positioned(
            left: 20,
            right: 20,
            bottom: -40,
            child: ContinueReadingBanner(
              sourate: _sourates.first,
              dernierVerset: 1,
              onTap: () {},
              isDarkMode: _isDarkMode,
            ),
          ),
      ],
    );
  }

  Color _bgRaised() => _isDarkMode ? AppColors.bgRaised : AppColors.bgRaisedLight;

  Widget _buildSourateList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 28),
      itemCount: _filteredSourates.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final sourate = _filteredSourates[index];
        return _SourateCard(
          sourate: sourate,
          onTap: () {},
          isDarkMode: _isDarkMode,
        );
      },
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final VoidCallback onTap;

  const _HeaderButton({this.icon, this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white24,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: label == null ? 42 : 52,
          height: 42,
          child: Center(
            child: label != null
                ? Text(
                    label!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : Icon(icon, color: Colors.white, size: 21),
          ),
        ),
      ),
    );
  }
}

class _SourateCard extends StatelessWidget {
  final Sourate sourate;
  final VoidCallback onTap;
  final bool isDarkMode;

  const _SourateCard({
    required this.sourate,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final bgSurface = isDarkMode ? AppColors.bgSurface : AppColors.bgSurfaceLight;
    final accent = isDarkMode ? AppColors.gold : AppColors.goldLight;
    final accentSoft = isDarkMode ? AppColors.goldSoft : AppColors.goldSoftLight;
    final text = isDarkMode ? AppColors.cream : AppColors.creamLight;
    final textSecondary = isDarkMode ? AppColors.textSecondary : AppColors.textSecondaryLight;
    final line = isDarkMode ? AppColors.line : AppColors.lineLight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgSurface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: line),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.06),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              SurahNumberBadge(number: sourate.numero, color: accent),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sourate.nom,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: text),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${sourate.traduction} · ${sourate.nombreVersets} versets',
                      style: TextStyle(fontSize: 12, color: textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                sourate.nomArabe,
                style: TextStyle(fontFamily: 'serif', fontSize: 17, color: accentSoft),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
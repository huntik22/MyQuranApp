import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/theme_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.bgDeepFor(isDarkMode),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildHeaderWithBanner(isDarkMode),
                  const SizedBox(height: 60),
                  Expanded(child: _buildSourateList(isDarkMode)),
                ],
              ),
      ),
    );
  }

  Widget _buildHeaderWithBanner(bool isDarkMode) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 78),
          decoration: BoxDecoration(
            color: AppColors.goldFor(isDarkMode),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Lecture du Coran',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      _HeaderButton(
                        icon: isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                        onTap: () => context.read<ThemeProvider>().toggleTheme(),
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
                  color: AppColors.bgRaisedFor(isDarkMode),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _search = value),
                  style: TextStyle(color: AppColors.creamFor(isDarkMode), fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Rechercher une sourate',
                    hintStyle: TextStyle(color: AppColors.textSecondaryFor(isDarkMode)),
                    prefixIcon: Icon(Icons.search, color: AppColors.goldSoftFor(isDarkMode)),
                    suffixIcon: _search.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _search = '');
                            },
                            icon: const Icon(Icons.close, size: 18),
                            color: AppColors.goldSoftFor(isDarkMode),
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
              isDarkMode: isDarkMode,
            ),
          ),
      ],
    );
  }

  Widget _buildSourateList(bool isDarkMode) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 28),
      itemCount: _filteredSourates.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final sourate = _filteredSourates[index];
        return _SourateCard(
          sourate: sourate,
          onTap: () {},
          isDarkMode: isDarkMode,
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.bgSurfaceFor(isDarkMode),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.lineFor(isDarkMode)),
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
              SurahNumberBadge(number: sourate.numero, color: AppColors.goldFor(isDarkMode)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sourate.nom,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.creamFor(isDarkMode),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${sourate.traduction} · ${sourate.nombreVersets} versets',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondaryFor(isDarkMode)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                sourate.nomArabe,
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 17,
                  color: AppColors.goldSoftFor(isDarkMode),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
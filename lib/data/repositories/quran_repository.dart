import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:quran/quran.dart' as quran_pkg;
import '../models/sourate.dart';
import '../models/verset.dart';
import '../models/page_coran.dart';

class QuranRepository {
  Future<List<Sourate>> getAllSourates() async {
    final jsonString = await rootBundle.loadString(
      'lib/data/sources/quran_data.json',
    );
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final list = data['sourates'] as List;
    return list.map((s) => Sourate.fromJson(s)).toList();
  }

  // ---- Nouvelles méthodes pour le mushaf ----

  static const int totalPages = quran_pkg.totalPagesCount;

  /// Reconstruit une page complète (1 à 604) avec tous ses versets.
  PageCoran getPage(int numeroPage) {
    final segments = quran_pkg.getPageData(numeroPage);
    final List<Verset> versets = [];

    for (final segment in segments) {
      final sourateNum = segment['surah'] as int;
      final debut = segment['start'] as int;
      final fin = segment['end'] as int;

      for (int v = debut; v <= fin; v++) {
        final texte = quran_pkg.getVerse(sourateNum, v);
        versets.add(Verset(numero: v, sourateNumero: sourateNum, texte: texte));
      }
    }

    return PageCoran(numero: numeroPage, versets: versets);
  }

  /// Donne la première page du Mushaf où commence une sourate.
  int getFirstPageOfSourate(int sourateNumero) {
    return quran_pkg.getSurahPages(sourateNumero).first;
  }
}
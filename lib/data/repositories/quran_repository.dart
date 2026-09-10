import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/sourate.dart';

class QuranRepository {
  Future<List<Sourate>> getAllSourates() async {
    final jsonString = await rootBundle.loadString(
      'lib/data/sources/quran_data.json',
    );
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final list = data['sourates'] as List;
    return list.map((s) => Sourate.fromJson(s)).toList();
  }
}
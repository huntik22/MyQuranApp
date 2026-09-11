import 'package:flutter/material.dart';

class AppColors {
  // ================== THÈME SOMBRE ==================
  static const Color bgDeep = Color(0xFF0B1F16);
  static const Color bgSurface = Color(0xFF15271E);
  static const Color bgRaised = Color(0xFF0E2A1F);
  static const Color gold = Color(0xFF3FAE7A);
  static const Color goldSoft = Color(0xFF2F9E70);
  static const Color goldDim = Color(0xFF24392F);
  static const Color cream = Color(0xFFEAF3EE);
  static const Color creamDim = Color(0xFFB7C9C0);
  static const Color textSecondary = Color(0xFF8FA79C);
  static const Color teal = Color(0xFF3FAE7A);
  static const Color line = Color(0xFF24392F);
  static const Color record = Color(0xFFB5533F);

  // ================== THÈME CLAIR ==================
  static const Color bgDeepLight = Color(0xFFF3FAF6);
  static const Color bgSurfaceLight = Color(0xFFFFFFFF);
  static const Color bgRaisedLight = Color(0xFFFFFFFF);
  static const Color goldLight = Color(0xFF2FA372);
  static const Color goldSoftLight = Color(0xFF34A374);
  static const Color goldDimLight = Color(0xFFD7EEE2);
  static const Color creamLight = Color(0xFF1E2A24);
  static const Color creamDimLight = Color(0xFFDDE8E2);
  static const Color textSecondaryLight = Color(0xFF7C8B84);
  static const Color tealLight = Color(0xFF2FA372);
  static const Color lineLight = Color(0xFFE1EEE7);
  static const Color recordLight = Color(0xFFA6483A);

  // ================== Méthodes qui choisissent selon le mode ==================
  static Color bgDeepFor(bool isDark) => isDark ? bgDeep : bgDeepLight;
  static Color bgSurfaceFor(bool isDark) => isDark ? bgSurface : bgSurfaceLight;
  static Color bgRaisedFor(bool isDark) => isDark ? bgRaised : bgRaisedLight;
  static Color goldFor(bool isDark) => isDark ? gold : goldLight;
  static Color goldSoftFor(bool isDark) => isDark ? goldSoft : goldSoftLight;
  static Color goldDimFor(bool isDark) => isDark ? goldDim : goldDimLight;
  static Color creamFor(bool isDark) => isDark ? cream : creamLight;
  static Color creamDimFor(bool isDark) => isDark ? creamDim : creamDimLight;
  static Color textSecondaryFor(bool isDark) => isDark ? textSecondary : textSecondaryLight;
  static Color lineFor(bool isDark) => isDark ? line : lineLight;
}
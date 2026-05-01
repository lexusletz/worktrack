import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../settings/settings_providers.dart';

final textThemeProvider = Provider<TextTheme>((ref) {
  final settings = ref.watch(settingsProvider);
  final fontFamily = settings.value?.fontFamily ?? FontFamilyOptions.FREDOKA;

  return switch (fontFamily) {
    FontFamilyOptions.MERRIWEATHER => GoogleFonts.merriweatherTextTheme(),
    FontFamilyOptions.INTER => GoogleFonts.interTextTheme(),
    FontFamilyOptions.POPPINS => GoogleFonts.poppinsTextTheme(),
    FontFamilyOptions.RUBIK => GoogleFonts.rubikTextTheme(),
    FontFamilyOptions.FREDOKA => GoogleFonts.fredokaTextTheme(),
  };
});

enum FontFamilyOptions { MERRIWEATHER, INTER, POPPINS, RUBIK, FREDOKA }

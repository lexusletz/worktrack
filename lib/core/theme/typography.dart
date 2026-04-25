import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:work_track/core/settings/settings_providers.dart';

final textThemeProvider = Provider<TextTheme>((ref) {
  final settings = ref.watch(settingsProvider);
  final fontFamily =
      settings.value?.fontFamily ?? FontFamilyOptions.merriweather;

  return switch (fontFamily) {
    FontFamilyOptions.merriweather => GoogleFonts.merriweatherTextTheme(),
    FontFamilyOptions.inter => GoogleFonts.interTextTheme(),
    FontFamilyOptions.poppins => GoogleFonts.poppinsTextTheme(),
    FontFamilyOptions.rubik => GoogleFonts.rubikTextTheme(),
    FontFamilyOptions.fredoka => GoogleFonts.fredokaTextTheme(),
  };
});

enum FontFamilyOptions { merriweather, inter, poppins, rubik, fredoka }

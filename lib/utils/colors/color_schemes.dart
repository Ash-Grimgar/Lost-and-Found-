import 'package:flutter/material.dart';

// Warm Cream & Muted Terracotta Palette (Warm Light Mode)
// Background / Neutrals: Warm oatmeal / cream (#FAF9F6)
// Primary / Structural: Muted terracotta / burnt orange (#C2410C / #DD6B20)
// Text / Accents: Deep espresso brown (#292524)
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFC2410C), // Muted terracotta
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFFFDBC8), // Soft peach terracotta container
  onPrimaryContainer: Color(0xFF380D00),
  secondary: Color(0xFFDD6B20), // Burnt orange accent
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFFBE4D8),
  onSecondaryContainer: Color(0xFF3B1200),
  tertiary: Color(0xFFB45309), // Warm amber-brown
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFED7AA),
  onTertiaryContainer: Color(0xFF2E1500),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFAF9F6), // Warm oatmeal / cream (60% background)
  onBackground: Color(0xFF292524), // Deep espresso brown text
  surface: Color(0xFFF5EFEB), // Warm structural surface (30% cards/containers)
  onSurface: Color(0xFF292524), // Deep espresso brown text
  surfaceVariant: Color(0xFFEAE2D9),
  onSurfaceVariant: Color(0xFF52443D),
  outline: Color(0xFFD7CCC8), // Soft warm border
  onInverseSurface: Color(0xFFFAF9F6),
  inverseSurface: Color(0xFF292524),
  inversePrimary: Color(0xFFFB923C),
  shadow: Color(0x1F292524),
  surfaceTint: Color(0xFFC2410C),
  outlineVariant: Color(0xFFE7E0D8),
  scrim: Color(0xFF292524),
);

// Warm Espresso & Terracotta Palette (Dark Mode)
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFFB923C), // Warm glowing terracotta
  onPrimary: Color(0xFF451A03),
  primaryContainer: Color(0xFF7C2D12),
  onPrimaryContainer: Color(0xFFFFDBC8),
  secondary: Color(0xFFFDBA74),
  onSecondary: Color(0xFF431407),
  secondaryContainer: Color(0xFF6B2B0B),
  onSecondaryContainer: Color(0xFFFED7AA),
  tertiary: Color(0xFFFDE68A),
  onTertiary: Color(0xFF451A00),
  tertiaryContainer: Color(0xFF5A3E00),
  onTertiaryContainer: Color(0xFFFFFBEB),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF1C1917), // Deep espresso slate
  onBackground: Color(0xFFFAF9F6), // Warm cream text
  surface: Color(0xFF292524), // Warm dark stone
  onSurface: Color(0xFFFAF9F6),
  surfaceVariant: Color(0xFF44403C),
  onSurfaceVariant: Color(0xFFD6D3D1),
  outline: Color(0xFF78716C),
  onInverseSurface: Color(0xFF1C1917),
  inverseSurface: Color(0xFFFAF9F6),
  inversePrimary: Color(0xFFC2410C),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFFB923C),
  outlineVariant: Color(0xFF57534E),
  scrim: Color(0xFF000000),
);

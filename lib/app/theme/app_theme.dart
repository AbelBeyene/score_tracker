import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const neonLemon = Color(0xFFC7F464);
  const darkBg = Color(0xFF0F1115);
  const darkSurface = Color(0xFF131720);
  const darkOn = Color(0xFFE6EAF2);

  final scheme = const ColorScheme.dark().copyWith(
    primary: neonLemon,
    onPrimary: Colors.black,
    primaryContainer: const Color(0xFFDBFA8F),
    onPrimaryContainer: Colors.black,
    secondary: const Color(0xFF5AA9E6),
    onSecondary: Colors.black,
    secondaryContainer: const Color(0xFF224860),
    onSecondaryContainer: darkOn,
    surface: darkSurface,
    onSurface: darkOn,
    background: darkBg,
    onBackground: darkOn,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: darkBg,
    appBarTheme: AppBarTheme(
      backgroundColor: darkBg,
      foregroundColor: darkOn,
      elevation: 0,
      centerTitle: true,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: scheme.secondaryContainer,
      labelStyle: TextStyle(color: scheme.onSecondaryContainer),
      selectedColor: scheme.secondary,
      secondaryLabelStyle: TextStyle(color: scheme.onSecondary),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: StadiumBorder(side: BorderSide(color: scheme.outlineVariant)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
        textStyle: const MaterialStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
      ),
    ),
    cardTheme: const CardThemeData(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 88, fontWeight: FontWeight.w800),
      displayMedium: TextStyle(fontSize: 64, fontWeight: FontWeight.w800),
      displaySmall: TextStyle(fontSize: 44, fontWeight: FontWeight.w800),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
    ).apply(bodyColor: darkOn, displayColor: darkOn),
  );
}

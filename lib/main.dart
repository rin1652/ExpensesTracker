import 'package:flutter/material.dart';

import 'widgets/expenses.dart';

import 'package:flutter/services.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 255, 159, 110),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: Color.fromARGB(255, 144, 190, 255),
  brightness: Brightness.dark,
);

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   //hướng thẳng đứng
  //   DeviceOrientation.portraitUp
  // ]).then((fn) {
  return runApp(
    MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: kDarkColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
          ),
        ),
      ),
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.primaryContainer,
          foregroundColor: kColorScheme.onPrimaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kColorScheme.onPrimaryContainer,
              ),
            ),
      ),
      themeMode: ThemeMode.light,
      home: const Expenses(),
    ),
  );
//   });
}

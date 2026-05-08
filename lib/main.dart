import 'package:flutter/material.dart';

import 'repositories/character_repository.dart';
import 'screens/intro_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/register_screen.dart';
import 'services/api_service.dart';
import 'services/local_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repository = CharacterRepository(
    apiService: ApiService(),
    localCharacterService: LocalCharacterService(),
  );

  runApp(CharacterBuilderApp(repository: repository));
}

class CharacterBuilderApp extends StatelessWidget {
  const CharacterBuilderApp({super.key, required this.repository});

  final CharacterRepository repository;
  static const Color _deepPurple = Color(0xFF2B124C);
  static const Color _darkGreen = Color(0xFF0F3028);
  static const Color _ravenBlue = Color(0xFF245E9F);
  static const Color _violet = Color(0xFF6D3BC4);
  static const Color _iceText = Color(0xFFEAF2FF);
  static const Color _paleLilac = Color(0xFFF7F1FF);
  static const Color _softViolet = Color(0xFFE2D2FF);
  static const Color _cardSurface = Color(0xFFFFFBFF);

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _deepPurple,
      brightness: Brightness.light,
      primary: _deepPurple,
      secondary: _violet,
      tertiary: _darkGreen,
      surface: _paleLilac,
    ).copyWith(
      onPrimary: _iceText,
      onSecondary: _iceText,
      onSurface: _deepPurple,
      primaryContainer: _softViolet,
      secondaryContainer: _paleLilac,
      outline: _violet,
    );

    return MaterialApp(
      title: 'Game of Thrones Character Builder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: _paleLilac,
        textTheme: ThemeData(
          brightness: Brightness.light,
        ).textTheme.apply(bodyColor: _deepPurple, displayColor: _deepPurple),
        appBarTheme: const AppBarTheme(
          backgroundColor: _deepPurple,
          foregroundColor: _iceText,
          centerTitle: true,
          elevation: 4,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: _iceText,
          ),
        ),
        cardTheme: CardThemeData(
          color: _cardSurface,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          surfaceTintColor: Colors.transparent,
          margin: const EdgeInsets.symmetric(vertical: 6),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: _deepPurple,
          foregroundColor: _iceText,
          elevation: 6,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: _cardSurface,
          indicatorColor: _softViolet,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            return TextStyle(
              fontSize: 15,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w600,
              color: states.contains(WidgetState.selected)
                  ? _deepPurple
                  : _ravenBlue,
            );
          }),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.72),
          labelStyle: const TextStyle(
            fontSize: 18,
            color: _deepPurple,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _violet),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _violet),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _deepPurple, width: 1.4),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: _deepPurple,
          contentTextStyle: TextStyle(
            fontSize: 16,
            color: _iceText,
          ),
        ),
      ),
      home: _RootFlowScreen(repository: repository),
    );
  }
}

class _RootFlowScreen extends StatefulWidget {
  const _RootFlowScreen({required this.repository});

  final CharacterRepository repository;

  @override
  State<_RootFlowScreen> createState() => _RootFlowScreenState();
}

class _RootFlowScreenState extends State<_RootFlowScreen> {
  bool _showIntro = true;
  bool _showRegister = false;

  void _openApp() {
    setState(() {
      _showIntro = false;
      _showRegister = false;
    });
  }

  void _openIntro() {
    setState(() {
      _showIntro = true;
      _showRegister = false;
    });
  }

  void _openRegister() {
    setState(() {
      _showIntro = false;
      _showRegister = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showIntro) {
      return IntroScreen(onStart: _openApp, onRegister: _openRegister);
    }

    if (_showRegister) {
      return RegisterScreen(
        onRegistered: _openApp,
        onBackToIntro: _openIntro,
      );
    }

    return MainNavigationScreen(
      repository: widget.repository,
      onShowIntro: _openIntro,
    );
  }
}

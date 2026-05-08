import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_app/repositories/character_repository.dart';
import 'package:flutter_testing_app/screens/create_character_screen.dart';
import 'package:flutter_testing_app/screens/intro_screen.dart';
import 'package:flutter_testing_app/screens/register_screen.dart';
import 'package:flutter_testing_app/services/api_service.dart';
import 'package:flutter_testing_app/services/local_service.dart';

void main() {
  testWidgets('intro start button opens the app area', (tester) async {
    await tester.pumpWidget(const _IntroTestHost());

    expect(find.text('LOAD APP'), findsOneWidget);
    expect(find.text('REGISTER'), findsOneWidget);
    expect(find.text('Opened Realm'), findsNothing);

    await tester.tap(find.text('LOAD APP'));
    await tester.pump();

    expect(find.text('Opened Realm'), findsOneWidget);
  });

  testWidgets('register button opens registration form', (tester) async {
    await tester.pumpWidget(const _IntroTestHost());

    await tester.tap(find.text('REGISTER'));
    await tester.pump();

    expect(find.text('Create account'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('create character form shows validation after Save tap', (
    tester,
  ) async {
    final repository = CharacterRepository(
      apiService: ApiService(),
      localCharacterService: LocalCharacterService(),
    );

    await tester.pumpWidget(
      MaterialApp(home: CreateCharacterScreen(repository: repository)),
    );

    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Please enter a name.'), findsOneWidget);
    expect(find.text('Please enter a title or skill.'), findsOneWidget);
  });
}

class _IntroTestHost extends StatefulWidget {
  const _IntroTestHost();

  @override
  State<_IntroTestHost> createState() => _IntroTestHostState();
}

class _IntroTestHostState extends State<_IntroTestHost> {
  bool opened = false;
  bool registering = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: opened
          ? const Scaffold(body: Center(child: Text('Opened Realm')))
          : registering
              ? RegisterScreen(
                  onRegistered: () {
                    setState(() {
                      opened = true;
                      registering = false;
                    });
                  },
                  onBackToIntro: () {
                    setState(() {
                      registering = false;
                    });
                  },
                )
              : IntroScreen(
                  onStart: () {
                    setState(() {
                      opened = true;
                    });
                  },
                  onRegister: () {
                    setState(() {
                      registering = true;
                    });
                  },
                ),
    );
  }
}

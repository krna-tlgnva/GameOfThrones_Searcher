# Assignment 7 Report: Introduction to Testing and Widget Testing

## Project Overview

Project name: `flutter_testing_app`

The application is a Game of Thrones character builder. It loads characters from ThronesAPI, lets the user create custom characters, and stores custom records locally on the device. The app has meaningful UI elements: an intro screen, buttons, text fields, a dropdown, cards, lists, details pages, and bottom navigation.

## Unit Testing

Unit tests are placed in:

- `test/character_validator_test.dart`

The unit tests check non-UI business logic in `CharacterValidator`:

- empty names are rejected;
- too short names are rejected;
- valid names and titles are accepted;
- extra spaces in user input are normalized.

These tests matter because form validation and data cleanup should work correctly even without rendering the Flutter widget tree.

## Widget Testing

Widget tests are placed in:

- `test/widget_test.dart`

The widget tests verify visible UI behavior:

- the intro screen shows the Game of Thrones title;
- tapping `Start Journey` changes the visible screen;
- tapping `Save` on an empty create form shows validation messages.

These tests matter because they confirm that important user-facing workflows still work after code changes.

## User Interaction Testing

The tests simulate real user actions with `WidgetTester`:

- `tester.tap(find.text('Start Journey'))`;
- `tester.tap(find.text('Save'))`.

After each interaction, the tests verify the expected UI result using `expect`.

## Test Execution Result

Command:

```text
flutter test --no-pub
```

Result:

```text
00:00 +5: All tests passed!
```

## Static Analysis Result

Command:

```text
flutter analyze --no-pub
```

Result:

```text
No issues found!
```

## Screenshots To Include In DOCX Submission

1. Running main screen of the app.
2. `test/character_validator_test.dart`.
3. `test/widget_test.dart`.
4. Terminal output showing `All tests passed!`.
5. Create character form after tapping `Save` with empty fields, showing validation messages.

## Summary

The project satisfies the Assignment 7 requirements because it includes a focused app topic, organized production code, a separate `test` folder, unit tests for non-UI logic, widget tests for visible screens, simulated user interactions, and passing automated test results.

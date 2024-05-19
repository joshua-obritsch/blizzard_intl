import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:blizzard_intl/blizzard_intl.dart' as intl;

enum Language {
  english,
  german,
}

const de = Language.german;
const en = Language.english;

class App extends StatelessWidget {
  const App({
    required this.defaultLanguage,
    this.selectedLanguage,
    required this.child,
  });

  final Language defaultLanguage;
  final Language? selectedLanguage;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return intl.LanguageWrapper<Language>(
      defaultLanguage: defaultLanguage,
      selectedLanguage: selectedLanguage,
      child: MaterialApp(
        home: Scaffold(
          body: child,
        ),
      ),
    );
  }
}

class ChangeLanguageButton extends StatelessWidget {
  const ChangeLanguageButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        final selectedLanguage =
            intl.LanguageManager.of<Language>(context).selectedLanguage;

        if (selectedLanguage == null || selectedLanguage == de) {
          intl.LanguageManager.of<Language>(context).onLanguageSelected(en);
        } else {
          intl.LanguageManager.of<Language>(context).onLanguageSelected(de);
        }
      },
      child: Text('+'),
    );
  }
}

void main() {
  group('LanguageWrapper', () {
    testWidgets('checks defaultLanguage', (tester) async {
      await tester.pumpWidget(
        App(
          defaultLanguage: de,
          child: intl.Text({
            de: 'Guten Tag',
            en: 'Hello',
          }),
        ),
      );

      final germanText = find.text('Guten Tag');
      final englishText = find.text('Hello');

      expect(germanText, findsOneWidget);
      expect(englishText, findsNothing);
    });

    testWidgets('checks selectedLanguage', (tester) async {
      await tester.pumpWidget(
        App(
          defaultLanguage: de,
          selectedLanguage: en,
          child: intl.Text({
            de: 'Guten Tag',
            en: 'Hello',
          }),
        ),
      );

      final germanText = find.text('Guten Tag');
      final englishText = find.text('Hello');

      expect(germanText, findsNothing);
      expect(englishText, findsOneWidget);
    });
  });

  group('LanguageManager', () {
    testWidgets('checks onSelectedLanguage', (tester) async {
      await tester.pumpWidget(
        App(
          defaultLanguage: de,
          child: Column(
            children: [
              intl.Text({
                de: 'Guten Tag',
                en: 'Hello',
              }),
              ChangeLanguageButton(),
            ],
          ),
        ),
      );

      final germanText = find.text('Guten Tag');
      final englishText = find.text('Hello');

      await tester.tap(find.byType(ChangeLanguageButton));
      await tester.pump();

      expect(germanText, findsNothing);
      expect(englishText, findsOneWidget);
    });
  });
}

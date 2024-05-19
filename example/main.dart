import 'package:blizzard_intl/blizzard_intl.dart';
import 'package:flutter/material.dart' hide Text;

enum Language {
  english,
  german,
}

const en = Language.english;
const de = Language.german;

typedef Translation = Map<Language, String>;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const LanguageWrapper<Language>(
      defaultLanguage: en,
      child: MaterialApp(
        title: 'Blizzard Intl',
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text({
          de: 'Guten Tag',
          en: 'Hello',
        }),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text({
              de: 'Drücken Sie den Button, um auf Englisch zu wechseln.',
              en: 'Push the button to change to German.',
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final selectedLanguage =
              LanguageManager.of<Language>(context).selectedLanguage;

          if (selectedLanguage == en) {
            LanguageManager.of<Language>(context).onLanguageSelected(de);
          } else {
            LanguageManager.of<Language>(context).onLanguageSelected(en);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

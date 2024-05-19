# Blizzard Intl

Blizzard Intl provides a means of facilitating the internationalization of
Flutter apps by offering a set of text-related widgets that take a
`Map<T, String>` instead of a `String` data type allowing you to pass in
multilingual translations instead of monolingual text.

## Basic Setup

1. Create an enum to represent the supported languages.
2. Optional: Create aliases for each language.
3. Optional: Create a typedef for the language map.
4. Wrap the app in a `LanguageWrapper` and set the default language.

### Step 1

Create an enumerated type to represent the supported languages of the app.

Example:

```dart
enum Language {
  english,
  german,
}
```

### Step 2 (Optional)

It is recommended to create aliases in the form of abbreviations for each value
of the enumerated language type.

Example:

```dart
const de = Language.german;
const en = Language.english;
```

### Step 3 (Optional)

It is recommended to create a typedef for the language map.

Example:

```dart
typedef Translation = Map<Language, String>;
```

### Step 4

Wrap the app in a `LanguageWrapper` and set the default language. You can
optionally set the selected language.

Example:

```dart
LanguageWrapper<Language>(
  defaultLanguage: en,
  child: MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text({
          de: 'Meine App',
          en: 'My App',
        }),
      ),
    ),
  ),
);
```

_Note: If `selectedLanguage` is `null`, then `defaultLanguage` will be used for
text widgets until a language is selected. If a translation is missing for the
selected language, the translation for the default language will be used._

### Complete Example

```dart
import 'package:blizzard_intl/blizzard_intl.dart' as intl;
import 'package:flutter/material.dart';

enum Language {
  english,
  german,
}

const de = Language.german;
const en = Language.english;

typedef Translation = Map<Language, String>;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return intl.LanguageWrapper<Language>(
      defaultLanguage: en,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const intl.Text({
              de: 'Meine App',
              en: 'My App',
            }),
          ),
        ),
      ),
    );
  }
}
```

## Obtaining the Language

The default or selected language can be obtained via `LanguageManager`.

Example:

```dart
final defaultLanguage =
    LanguageManager.of<Language>(context).defaultLanguage;
final selectedLanguage =
    LanguageManager.of<Language>(context).selectedLanguage;
```

_Note: This is generally not needed as the provided text widgets handle this
under the hood._

## Selecting the Language

The language can be selected by calling the `onLanguageSelected` method of
`LanguageManager`.

Example:

```dart
LanguageManager.of<Language>(context).onLanguageSelected(de);
```

## Separation of Concerns

Given that Blizzard Intl favors Locality of Behavior (LoB), it is recommended to
split translations up into local and global translations, whereby local should
be preferred over global by default and only promoted to global when necessary.

### Local Translations

Local translations define the translations directly on the widget where the text
should appear.

Example:

```dart
class ConfirmButton extends StatelessWidget {
  const ConfirmButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: intl.Text({
        de: 'Bestätigen',
        en: 'Confirm',
      }),
    );
  }
}
```

### Global Translations

Global translations define the translations in a global file which is then
imported locally.

Example:

`translations.dart`

```dart
const Translation confirmText = {
  de: 'Bestätigen',
  en: 'Confirm',
};
```

`confirm_button.dart`

```dart
import 'package:blizzard_intl/blizzard_intl.dart' as intl;
import 'package:flutter/material.dart';

import 'translations.dart' as translations;

class ConfirmButton extends StatelessWidget {
  const ConfirmButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: intl.Text(translations.confirmText),
    );
  }
}
```

## Import Conflicts

The text widgets provided by Blizzard Intl correspond exactly to their Flutter
equivalents both in naming and parameters. This means they function exactly in
the same way, the only difference being that any `String` parameter should be
replaced by `Map<T, String>`. This includes `semanticsLabel`.

There are cases when providing multiple translations would be unnecessary, such
as when displaying a counter to the user. So Blizzard Intl does not make
Flutter's `String`-based widgets obsolete.

It is therefore recommended to use a qualified import for Blizzard Intl as in
the following example:

```dart
import 'package:blizzard_intl/blizzard_intl' as intl;
```

An alternative approach that may be useful for projects that rarely use
monolingual text would be to create a prelude file such as `prelude.dart` in the
base of `lib`, export the desired defaults, and then use a qualified import for
Flutter when using monolingual text as in the following example:

`prelude.dart`

```dart
export 'package:blizzard_intl/blizzard_intl.dart';
export 'package:flutter/material.dart'
    hide InlineSpan, RichText, Text, TextSpan, WidgetSpan;
```

`my_app.dart`

```dart
import 'package:flutter/material.dart' as flutter;

import 'prelude.dart';
```

## Rationale

Actually, I've spent quite a bit of time over the past few years, sort of on and
off, researching different ways to structure a front-end application in a
scalable way. I've tried many different things both professionally and in my
free time from making simple game engines in C to developing e-learning
applications in vanilla JavaScript, React and Elm to writing business software
in Dart and Flutter. What, in my opinion, tends to make scaling front-end
applications difficult is the way in which people deal with separation of
concerns. This is a very deep topic, but to keep myself from turning this README
into a book, let's just say I like to keep related things together. This
includes markup, styling, internationalization, behavior etc. Let me give you a
simple example.

Let's say we want to make our app multilingual. What a lot of people do is use
something like i18n where all the text is stored in some central file. You then
end up naming each piece of text. If the text is short and simple, then you can
have something like this:

```
en:
    submit: 'Submit'

de:
    submit: 'Bestätigen'
```

And for simple, frequently used text, this is mostly fine. One issue with this
kind of global text, however, is that sometimes you want different translations
for a particular language. Perhaps for a particular button, we don't want the
English version to be 'Submit', but rather 'Confirm'. We want the German version
to be the same in both cases. So now we end up with this:

```
en:
    submit_button_on_form: 'Confirm'
    global_submit_button: 'Submit'

de:
    submit_button_on_form: 'Bestätigen'
    global_submit_button: 'Bestätigen'
```

As the application grows and becomes more complicated, the translations become
more and more fragmented and it becomes difficult to know which components in
the app will be affected if I change this line. Usually you end up having to do
a search and then manually confirm each change. There was actually a post on
Hacker News not long ago about how Microsoft mistranslated "Zip" for "Postal
Code" in the context of zipping a file. This stuff is hard.

Another issue is that you often end up with longer text that is much more
difficult to name like this:

```
en:
    warning2: 'Please note that you are legally required to take a break for '
              'at least 15 minutes every 4 hours of work.'

de:
    warning2: 'Bitte beachten Sie, dass Sie verpflichtet sind, alle 4 Stunden '
              'eine Pause von mindestens 15 Minuten zu machen.'
```

*warning2* is pretty vague here and if poorly named, can also be very
misleading. It says it's a warning, but in the app I see red text and an error
symbol. This isn't a warning at all. Also, our UX team said to make a text
change to *warning3*, but the text for *warning3* is completely different. Did
they confuse *warning2* with *warning3* or was it wrong in the app all along?

Naming stuff is a language and communication problem in general. And again,
these differences in naming, understanding and communicating often result in
fragmentations that can go unnoticed and make their way into production.

What helps, although it's certainly not a solution to the limitations of
language and communication, is putting stuff where it belongs. If you have a
component or some markup, put the translation on that component. If you make any
changes, then you'll immediately see exactly which component it will affect. If
that component is being used in multiple places, then you can do a direct search
without first having to map the translation to the key to the component or
components.

I feel the same fragmentation happens with CSS and that's why people are moving
toward something like Tailwind CSS. That isn't to say that globals should always
be avoided, but it often feels like the programming community is split between
those who always use globals and those who never use globals, ever, and there is
no middle ground that uses both appropriately when needed. (I'm using the terms
local and global here in a very abstract sense, not only referring to state.)

library blizzard_intl;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart'
    hide InlineSpan, RichText, Text, TextSpan, WidgetSpan;
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

/// A language manager that provides a means of accessing the default and
/// selected languages of the application as well as a method to change the
/// currently selected language.
///
/// Can be used as follows to obtain the default and selected languages.
///
/// Example:
///
/// ```dart
/// final defaultLanguage =
///     LanguageManager.of<Language>(context).defaultLanguage;
/// final selectedLanguage =
///     LanguageManager.of<Language>(context).selectedLanguage;
/// ```
///
/// Can be used as follows to change the currently selected language to `de`.
///
/// Example:
///
/// ```dart
/// LanguageManager.of<Language>(context).onLanguageSelected(de);
/// ```
class LanguageManager<T> extends InheritedWidget {
  /// Constructs an instance of [LanguageManager].
  const LanguageManager({
    super.key,
    required this.defaultLanguage,
    required this.selectedLanguage,
    required this.onLanguageSelected,
    required super.child,
  });

  /// The default language of the application.
  final T defaultLanguage;

  /// The currently selected language of the application.
  final T? selectedLanguage;

  /// Changes the currently selected language of the application.
  final void Function(T) onLanguageSelected;

  /// Retrieves an instance of [LanguageManager] if one exists.
  static LanguageManager<T>? maybeOf<T>(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LanguageManager<T>>();

  /// Retrieves an instance of [LanguageManager].
  static LanguageManager<T> of<T>(BuildContext context) {
    final result = maybeOf<T>(context);

    assert(result != null, 'No LanguageManager found in context');

    return result!;
  }

  /// Updates all multilingual text nodes when the selected language changes.
  @override
  bool updateShouldNotify(LanguageManager<T> oldWidget) =>
      selectedLanguage != oldWidget.selectedLanguage;
}

/// A language wrapper that holds the language-related state for the
/// application including both the default and selected language.
///
/// Example:
///
/// ```dart
/// LanguageWrapper<Language>(
///   defaultLanguage: en,
///   child: MaterialApp(
///     home: Scaffold(
///       appBar: AppBar(
///         title: const Text({
///           de: 'Meine App',
///           en: 'My App',
///         }),
///       ),
///     ),
///   ),
/// );
/// ```
class LanguageWrapper<T> extends StatefulWidget {
  /// Constructs an instance of [LanguageWrapper].
  const LanguageWrapper({
    super.key,
    required this.defaultLanguage,
    this.selectedLanguage,
    required this.child,
  });

  /// The default language of the application.
  final T defaultLanguage;

  /// The currently selected language of the application.
  final T? selectedLanguage;

  /// The child widget that [LanguageWrapper] wraps.
  final Widget child;

  /// Creates an instance of [_LanguageWrapperState].
  @override
  State<LanguageWrapper<T>> createState() => _LanguageWrapperState<T>();
}

/// The state for [LanguageWrapper].
class _LanguageWrapperState<T> extends State<LanguageWrapper<T>> {
  /// Changes the currently selected language of the application.
  void onLanguageSelected(T selectedLanguage) {
    setState(() {
      this.selectedLanguage = selectedLanguage;
    });
  }

  /// The currently selected language of the application.
  T? selectedLanguage;

  @override
  Widget build(context) => LanguageManager<T>(
        defaultLanguage: widget.defaultLanguage,
        selectedLanguage: selectedLanguage ??
            widget.selectedLanguage ??
            widget.defaultLanguage,
        onLanguageSelected: onLanguageSelected,
        child: widget.child,
      );
}

/// A multilingual text node equivalent to [flutter.Text] but uses
/// `Map<T, String>` instead of `String` for `data` and `semanticsLabel`.
class Text<T> extends StatelessWidget {
  /// Constructs an instance of [Text] equivalent to [flutter.Text].
  ///
  /// Example:
  ///
  /// ```dart
  /// Text({
  ///   de: 'Guten Tag',
  ///   en: 'Hello',
  /// })
  /// ```
  const Text(
    Map<T, String> this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  }) : textSpan = null;

  /// Constructs an instance of [Text] equivalent to [flutter.Text.rich].
  ///
  /// Example:
  ///
  /// ```dart
  /// Text.rich(
  ///   TextSpan(
  ///     text: {
  ///       de: 'Sie trug ein ',
  ///       en: 'She wore a ',
  ///     },
  ///     children: <TextSpan>[
  ///       TextSpan(
  ///         text: {
  ///           de: 'schönes ',
  ///           en: 'beautiful '
  ///         },
  ///         style: TextStyle(fontStyle: FontStyle.italic),
  ///       ),
  ///       TextSpan(
  ///         text: {
  ///           de: 'Kleid ',
  ///           en: 'dress '
  ///         },
  ///         style: TextStyle(fontWeight: FontWeight.bold),
  ///       ),
  ///       TextSpan(
  ///         text: {
  ///           de: 'zur Party.',
  ///           en: 'to the party.'
  ///         },
  ///       ),
  ///     ],
  ///   ),
  /// )
  /// ```
  const Text.rich(
    InlineSpan<T> this.textSpan, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  }) : data = null;

  /// See: [flutter.Text.data].
  final Map<T, String>? data;

  /// See: [flutter.Text.textSpan].
  final InlineSpan<T>? textSpan;

  /// See: [flutter.Text.style].
  final TextStyle? style;

  /// See: [flutter.Text.strutStyle].
  final StrutStyle? strutStyle;

  /// See: [flutter.Text.textAlign].
  final TextAlign? textAlign;

  /// See: [flutter.Text.textDirection].
  final TextDirection? textDirection;

  /// See: [flutter.Text.locale].
  final Locale? locale;

  /// See: [flutter.Text.softWrap].
  final bool? softWrap;

  /// See: [flutter.Text.overflow].
  final TextOverflow? overflow;

  /// See: [flutter.Text.textScaler].
  final TextScaler? textScaler;

  /// See: [flutter.Text.maxLines].
  final int? maxLines;

  /// See: [flutter.Text.semanticsLabel].
  final Map<T, String>? semanticsLabel;

  /// See: [flutter.Text.textWidthBasis].
  final TextWidthBasis? textWidthBasis;

  /// See: [flutter.Text.textHeightBehavior].
  final TextHeightBehavior? textHeightBehavior;

  /// See: [flutter.Text.selectionColor].
  final Color? selectionColor;

  @override
  Widget build(BuildContext context) {
    final defaultLanguage = LanguageManager.of<T>(context).defaultLanguage;
    final selectedLanguage = LanguageManager.of<T>(context).selectedLanguage;

    if (textSpan != null) {
      return flutter.Text.rich(
        switch (textSpan!) {
          TextSpan<T> e => e.toInternal(defaultLanguage, selectedLanguage),
          WidgetSpan e => e.toInternal(),
        },
        style: style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaler: textScaler,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel?[selectedLanguage] ??
            semanticsLabel?[defaultLanguage],
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        selectionColor: selectionColor,
      );
    }

    return flutter.Text(
      data?[selectedLanguage] ?? data?[defaultLanguage] ?? '',
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel:
          semanticsLabel?[selectedLanguage] ?? semanticsLabel?[defaultLanguage],
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}

/// A multilingual rich text node equivalent to [flutter.RichText] but uses
/// [InlineSpan] instead of [flutter.InlineSpan].
///
/// Example:
///
/// ```dart
/// RichText(
///   text: TextSpan(
///     text: {
///       de: 'Der ',
///       en: 'The ',
///     },
///     children: <TextSpan>[
///       TextSpan(
///         text: {
///           de: 'stille ',
///           en: 'quiet '
///         },
///         style: TextStyle(fontStyle: FontStyle.italic),
///       ),
///       TextSpan(
///         text: {
///           de: 'Wald ',
///           en: 'forest '
///         },
///         style: TextStyle(fontWeight: FontWeight.bold),
///       ),
///       TextSpan(
///         text: {
///           de: 'war bezaubernd.',
///           en: 'was enchanting.'
///         },
///       ),
///     ],
///   ),
/// )
/// ```
class RichText<T> extends StatelessWidget {
  /// Constructs an instance of [RichText] equivalent to [flutter.RichText].
  const RichText({
    super.key,
    required this.text,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaler = TextScaler.noScaling,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
    this.selectionRegistrar,
    this.selectionColor,
  });

  /// See: [flutter.RichText.text].
  final InlineSpan<T> text;

  /// See: [flutter.RichText.textAlign].
  final TextAlign textAlign;

  /// See: [flutter.RichText.textDirection].
  final TextDirection? textDirection;

  /// See: [flutter.RichText.softWrap].
  final bool softWrap;

  /// See: [flutter.RichText.overflow].
  final TextOverflow overflow;

  /// See: [flutter.RichText.textScaler].
  final TextScaler textScaler;

  /// See: [flutter.RichText.maxLines].
  final int? maxLines;

  /// See: [flutter.RichText.locale].
  final Locale? locale;

  /// See: [flutter.RichText.strutStyle].
  final StrutStyle? strutStyle;

  /// See: [flutter.RichText.textWidthBasis].
  final TextWidthBasis textWidthBasis;

  /// See: [flutter.RichText.textHeightBehavior].
  final TextHeightBehavior? textHeightBehavior;

  /// See: [flutter.RichText.selectionRegistrar].
  final SelectionRegistrar? selectionRegistrar;

  /// See: [flutter.RichText.selectionColor].
  final Color? selectionColor;

  @override
  Widget build(BuildContext context) {
    final defaultLanguage = LanguageManager.of<T>(context).defaultLanguage;
    final selectedLanguage = LanguageManager.of<T>(context).selectedLanguage;

    return flutter.RichText(
      text: switch (text) {
        TextSpan<T> e => e.toInternal(defaultLanguage, selectedLanguage),
        WidgetSpan e => e.toInternal(),
      },
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionRegistrar: selectionRegistrar,
      selectionColor: selectionColor,
    );
  }
}

/// A multilingual inline span node equivalent to [flutter.InlineSpan].
sealed class InlineSpan<T> {
  /// Constructs an instance of [InlineSpan] equivalent to [flutter.InlineSpan].
  const InlineSpan();
}

/// A multilingual text span node equivalent to [flutter.TextSpan] but uses
/// `Map<T, String>` instead of `String` for `text` and `semanticsLabel`.
///
/// Example:
///
/// ```dart
/// TextSpan(
///   text: {
///     de: 'Auf Wiedersehen!',
///     en: 'Goodbye!',
///   },
/// )
/// ```
class TextSpan<T> extends InlineSpan<T> {
  /// Constructs an instance of [TextSpan] equivalent to [flutter.TextSpan].
  const TextSpan({
    this.text,
    this.children,
    this.style,
    this.recognizer,
    MouseCursor? mouseCursor,
    this.onEnter,
    this.onExit,
    this.semanticsLabel,
    this.locale,
    this.spellOut,
  }) : mouseCursor = mouseCursor ??
            (recognizer == null ? MouseCursor.defer : SystemMouseCursors.click);

  /// See: [flutter.TextSpan.text].
  final Map<T, String>? text;

  /// See: [flutter.TextSpan.children].
  final List<InlineSpan<T>>? children;

  /// See: [flutter.TextSpan.style].
  final TextStyle? style;

  /// See: [flutter.TextSpan.recognizer].
  final GestureRecognizer? recognizer;

  /// See: [flutter.TextSpan.mouseCursor].
  final MouseCursor mouseCursor;

  /// See: [flutter.TextSpan.onEnter].
  final PointerEnterEventListener? onEnter;

  /// See: [flutter.TextSpan.onExit].
  final PointerExitEventListener? onExit;

  /// See: [flutter.TextSpan.semanticsLabel].
  final Map<T, String>? semanticsLabel;

  /// See: [flutter.TextSpan.locale].
  final Locale? locale;

  /// See: [flutter.TextSpan.spellOut].
  final bool? spellOut;

  /// Converts [this] into [flutter.TextSpan].
  flutter.InlineSpan toInternal(T defaultLanguage, T? selectedLanguage) =>
      flutter.TextSpan(
        text: text?[selectedLanguage] ?? text?[defaultLanguage],
        children: children
            ?.map(
              (e) => switch (e) {
                TextSpan<T> e =>
                  e.toInternal(defaultLanguage, selectedLanguage),
                WidgetSpan e => e.toInternal(),
              },
            )
            .toList(),
        style: style,
        recognizer: recognizer,
        mouseCursor: mouseCursor,
        onEnter: onEnter,
        onExit: onExit,
        semanticsLabel: semanticsLabel?[selectedLanguage] ??
            semanticsLabel?[defaultLanguage],
        locale: locale,
        spellOut: spellOut,
      );
}

/// A multilingual widget span node equivalent to [flutter.WidgetSpan].
class WidgetSpan extends InlineSpan {
  /// Constructs an instance of [WidgetSpan] equivalent to [flutter.WidgetSpan].
  const WidgetSpan({
    required this.child,
    this.alignment = PlaceholderAlignment.bottom,
    this.baseline,
    this.style,
  });

  /// See: [flutter.WidgetSpan.child].
  final Widget child;

  /// See: [flutter.WidgetSpan.alignment].
  final PlaceholderAlignment alignment;

  /// See: [flutter.WidgetSpan.baseline].
  final TextBaseline? baseline;

  /// See: [flutter.WidgetSpan.style].
  final TextStyle? style;

  /// Converts [this] into [flutter.InlineSpan].
  flutter.InlineSpan toInternal() => flutter.WidgetSpan(
        child: child,
        alignment: alignment,
        baseline: baseline,
        style: style,
      );
}

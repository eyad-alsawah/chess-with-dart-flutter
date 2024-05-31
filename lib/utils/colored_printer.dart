import 'package:flutter/foundation.dart';

enum AnsiColor {
  black,
  red,
  green,
  yellow,
  blue,
  magenta,
  cyan,
  white,
  reset,
}

class ColoredPrinter {
  static const Map<AnsiColor, String> _colorCodes = {
    AnsiColor.black: '\x1B[30m',
    AnsiColor.red: '\x1B[31m',
    AnsiColor.green: '\x1B[32m',
    AnsiColor.yellow: '\x1B[33m',
    AnsiColor.blue: '\x1B[34m',
    AnsiColor.magenta: '\x1B[35m',
    AnsiColor.cyan: '\x1B[36m',
    AnsiColor.white: '\x1B[37m',
    AnsiColor.reset: '\x1B[0m',
  };

  static void printLine(
      [String pre = '', String suf = '╝', AnsiColor color = AnsiColor.blue]) {
    ColoredPrinter.printColored('$pre${'═' * 100}$suf', color);
  }

  static void printColored(Object? object,
      [AnsiColor color = AnsiColor.green]) {
    final ansiCode = _colorCodes[color];
    if (ansiCode != null) {
      print('$ansiCode$object${_colorCodes[AnsiColor.reset]}');
    } else {
      if (kDebugMode) {
        print('Unknown color: $color');
      }
    }
  }
}

void printBoxed({required String text, AnsiColor color = AnsiColor.blue}) {
  final lines = text.split('\n');

  ColoredPrinter.printLine('╔', '╗', color);

  for (final line in lines) {
    ColoredPrinter.printColored('║  $line', color);
  }

  ColoredPrinter.printLine('╚', '╝', color);
}

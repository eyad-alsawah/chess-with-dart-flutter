import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/global_state.dart';
import '../utils/colored_printer.dart';
import 'enums.dart';
import 'shared_state.dart';

class UciController {
  static Future<void> getBestMove(String move) async {
    ColoredPrinter.printColored(move, AnsiColor.magenta);
    const url =
        'http://192.168.1.101:3000/send-command'; // Replace with your server's URL
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'command': move});

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        String startPosition = response.body.substring(0, 2);
        String endPosition = response.body.substring(2, 4);

        SharedState.instance.bestMoveStartPos =
            ChessSquare.values.firstWhere((e) => e.name == startPosition).index;
        SharedState.instance.bestMoveEndPos =
            ChessSquare.values.firstWhere((e) => e.name == endPosition).index;
        callbacks.updateView();
        ColoredPrinter.printColored('Best Move: ${response.body}');
      } else {
        ColoredPrinter.printColored(
            'Failed to send move. Status code: ${response.statusCode}',
            AnsiColor.red);
      }
    } catch (e) {
      ColoredPrinter.printColored('Error sending move: $e', AnsiColor.red);
    }
  }

  static Future<void> newGame() async {
    const url =
        'http://192.168.1.101:3000/new-game'; // Replace with your server's URL
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        ColoredPrinter.printColored('New Game Started Successfully');
      } else {
        ColoredPrinter.printColored(
            'Error starting new game: Status Code ${response.statusCode}',
            AnsiColor.red);
      }
    } catch (e) {
      ColoredPrinter.printColored('Error starting new game: $e', AnsiColor.red);
    }
  }
}

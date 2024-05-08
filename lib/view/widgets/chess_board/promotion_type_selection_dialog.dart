import 'dart:math';

import 'package:chess/controllers/enums.dart';
import 'package:chess/utils/image_assets.dart';
import 'package:flutter/material.dart';

Future<Pieces> showPromotionTypeSelectionDialog(
    PlayingTurn playingTurn, BuildContext context) async {
  return await showDialog(
      useRootNavigator: true,
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          content: Transform.rotate(
            angle: playingTurn == PlayingTurn.white ? 0 : pi,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFFB58863),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              height: 100,
              width: 100,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(dialogContext, rootNavigator: true)
                            .pop(Pieces.rook);
                      },
                      child: Image.asset(
                        playingTurn == PlayingTurn.white
                            ? whiteCastle
                            : blackCastle,
                      ),
                    ),
                  ),
                  Container(
                    width: 2,
                    color: Colors.black,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(dialogContext, rootNavigator: true)
                            .pop(Pieces.knight);
                      },
                      child: Image.asset(
                        playingTurn == PlayingTurn.white
                            ? whiteKnight
                            : blackKnight,
                      ),
                    ),
                  ),
                  Container(
                    width: 2,
                    color: Colors.black,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(dialogContext, rootNavigator: true)
                            .pop(Pieces.bishop);
                      },
                      child: Image.asset(
                        playingTurn == PlayingTurn.white
                            ? whiteBishop
                            : blackBishop,
                      ),
                    ),
                  ),
                  Container(
                    width: 2,
                    color: Colors.black,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(dialogContext, rootNavigator: true)
                            .pop(Pieces.queen);
                      },
                      child: Image.asset(
                        playingTurn == PlayingTurn.white
                            ? whiteQueen
                            : blackQueen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

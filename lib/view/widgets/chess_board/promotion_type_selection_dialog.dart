import 'dart:math';

import 'package:chess/controllers/enums.dart';
import 'package:chess/utils/image_assets.dart';
import 'package:chess/view/utils/sizes_manager.dart';
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
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppSizeR.s12))),
          content: Transform.rotate(
            angle: playingTurn == PlayingTurn.white ? 0 : pi,
            child: Container(
              padding: EdgeInsets.all(AppSizeW.s10),
              decoration: BoxDecoration(
                color: const Color(0xFFB58863),
                borderRadius: BorderRadius.all(Radius.circular(AppSizeR.s12)),
              ),
              height: AppSizeH.s100,
              width: AppSizeW.s100,
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
                    width: AppSizeW.s2,
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
                    width: AppSizeW.s2,
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
                    width: AppSizeW.s2,
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

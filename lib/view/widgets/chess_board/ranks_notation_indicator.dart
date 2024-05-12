import 'dart:math';

import 'package:chess/view/widgets/chess_board/chess_board_widget.dart';
import 'package:flutter/material.dart';

class RanksNotationIndicator extends StatelessWidget {
  final double size;
  final bool right;
  const RanksNotationIndicator(
      {super.key, required this.size, required this.right});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size * 0.8,
      width: size * 0.08,
      child: ListView.builder(
          itemCount: 8,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          reverse: true,
          itemBuilder: (context, index) {
            return SizedBox(
              height: size * 0.1,
              width: size * 0.08,
              child: Center(
                child: Transform.rotate(
                  angle: right ? pi : 0,
                  child: FittedBox(
                    child: Text(
                      ranksNotation[index],
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

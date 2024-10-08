import 'dart:math';
import 'package:chess/controllers/enums.dart';
import 'package:flutter/material.dart';

class FilesNotationIndicator extends StatelessWidget {
  final double size;
  final bool top;
  const FilesNotationIndicator(
      {super.key, required this.size, required this.top});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size * 0.08,
      child: Row(
        children: [
          SizedBox(
            width: size * 0.08,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 8,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: size * 0.1,
                  child: Center(
                    child: Transform.rotate(
                      angle: top ? pi : 0,
                      child: FittedBox(
                        child: Text(
                          Files.values[index].name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

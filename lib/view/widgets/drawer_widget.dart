import 'package:chess/core/theme/color_manager.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  final VoidCallback onResetGame;
  final VoidCallback updateView;
  const DrawerWidget(
      {super.key, required this.onResetGame, required this.updateView});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.6,
      backgroundColor: const Color.fromARGB(255, 38, 37, 33),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GestureDetector(
                onTap: () async => widget.onResetGame(),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Reset Game',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.restart_alt_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              color: Colors.white30,
              thickness: 2,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Apperance:',
                    style: TextStyle(
                        color: Colors.white60, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      ColorManager.darkSquare = ColorManager.darkSquareChess;
                      ColorManager.lightSquare = ColorManager.lightSquareChess;
                      setState(() {});
                      widget.updateView();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorManager.lightSquare ==
                                  ColorManager.lightSquareChess
                              ? Colors.red
                              : const Color.fromARGB(255, 38, 37, 33),
                        ),
                      ),
                      width: 32,
                      height: 32,
                      child: Row(
                        children: [
                          Container(
                              width: 15,
                              height: 30,
                              color: ColorManager.darkSquareChess),
                          Container(
                              width: 15,
                              height: 30,
                              color: ColorManager.lightSquareChess),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      ColorManager.darkSquare = ColorManager.darkSquareLichess;
                      ColorManager.lightSquare =
                          ColorManager.lightSquareLichess;
                      setState(() {});
                      widget.updateView();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorManager.lightSquare ==
                                  ColorManager.lightSquareLichess
                              ? Colors.red
                              : const Color.fromARGB(255, 38, 37, 33),
                        ),
                      ),
                      width: 32,
                      height: 32,
                      child: Row(
                        children: [
                          Container(
                              width: 15,
                              height: 30,
                              color: ColorManager.darkSquareLichess),
                          Container(
                              width: 15,
                              height: 30,
                              color: ColorManager.lightSquareLichess),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.white30,
              thickness: 2,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:chess/core/theme/color_manager.dart';
import 'package:chess/utils/debug_config.dart';
import 'package:chess/view/utils/sizes_manager.dart';
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
            SizedBox(height: AppSizeH.s100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GestureDetector(
                onTap: () async => widget.onResetGame(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Reset Game',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: AppSizeW.s4),
                    const Icon(
                      Icons.restart_alt_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.white30,
              thickness: AppSizeW.s2,
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
            SizedBox(height: AppSizeH.s10),
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
                      width: AppSizeW.s33,
                      height: AppSizeH.s33,
                      child: Row(
                        children: [
                          Container(
                              width: AppSizeW.s15,
                              height: AppSizeH.s30,
                              color: ColorManager.darkSquareChess),
                          Container(
                              width: AppSizeW.s15,
                              height: AppSizeH.s30,
                              color: ColorManager.lightSquareChess),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizeW.s15),
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
                      width: AppSizeW.s33,
                      height: AppSizeH.s33,
                      child: Row(
                        children: [
                          Container(
                              width: AppSizeW.s15,
                              height: AppSizeH.s30,
                              color: ColorManager.darkSquareLichess),
                          Container(
                              width: AppSizeW.s15,
                              height: AppSizeH.s30,
                              color: ColorManager.lightSquareLichess),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.white30,
              thickness: AppSizeW.s2,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Developer Options:',
                    style: TextStyle(
                        color: Colors.white60, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizeH.s10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Show all moves',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Switch.adaptive(
                      activeColor: ColorManager.lightSquare,
                      value: DebugConfig.displayAllLegalAndIllegalMoves,
                      onChanged: (v) {
                        DebugConfig.displayAllLegalAndIllegalMoves = v;
                        setState(() {});
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

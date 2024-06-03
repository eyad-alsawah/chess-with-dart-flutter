import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/legal_moves_controller.dart';
import 'package:chess/controllers/shared_state.dart';

import 'package:chess/model/global_state.dart';
import 'package:chess/model/chess_board_model.dart';
import 'package:chess/utils/extensions.dart';

class GameStatusController {
  // Private constructor
  GameStatusController._private();

  // Private static instance
  static final GameStatusController _instance = GameStatusController._private();

  // Public static method to access the instance
  static GameStatusController get instance => _instance;
  //----------------------------------------------------------------------------

  static Future<SoundType?> checkStatus(PieceType? kingTypeToCheck) async {
    SoundType? soundToPlay;
    SharedState.instance.checkedKingIndex = null;
    SharedState.instance.isKingChecked = await gameStatusController
        .isKingSquareAttacked(kingTypeToCheck: kingTypeToCheck);
    if (SharedState.instance.isKingChecked) {
      SharedState.instance.checkedKingIndex =
          ChessBoardModel.getIndexWherePieceAndPieceTypeMatch(
              Pieces.king, kingTypeToCheck);
      if (await gameStatusController.isCheckmate(
          playingTurn: kingTypeToCheck!.playingTurn())) {
        helperMethods.preventFurtherInteractions(true);
        callbacks.onVictory(VictoryType.checkmate);
        soundToPlay = SoundType.victory;
      }
    } else {
      bool isStalemate =
          await gameStatusController.checkForStaleMate(kingTypeToCheck);
      bool isFiftyMoveRule =
          !isStalemate && SharedState.instance.halfMoveClock >= 100;
      bool isThreefoldRepetition = checkForThreeFoldRepetition();

      if (isStalemate || isFiftyMoveRule || isThreefoldRepetition) {
        helperMethods.preventFurtherInteractions(true);
        DrawType? drawType;
        if (isStalemate) {
          drawType = DrawType.stalemate;
        } else if (isFiftyMoveRule) {
          drawType = DrawType.fiftyMoveRule;
        } else if (isThreefoldRepetition) {
          drawType = DrawType.threeFoldRepetition;
        }
        callbacks.onDraw(drawType!);
        soundToPlay = SoundType.draw;
      }
    }

    return soundToPlay;
  }

  static bool checkForThreeFoldRepetition() {
    RegExp halfMoveClockAndFullMoveNumberRegExp = RegExp(r'\s\d+\s\d+$');
    Map<String, int> positionCounts = {};

    // Using a regex to remove castling rights/enPassant, half-move clock, and full-move number from FEN strings before comparing them
    List<String> positions = SharedState.instance.fenStrings
        .map((fen) => fen.replaceAll(halfMoveClockAndFullMoveNumberRegExp, ''))
        .toList();

    for (int i = 0; i < positions.length; i++) {
      String currentPosition = positions[i];
      if (positionCounts.containsKey(currentPosition)) {
        positionCounts[currentPosition] = positionCounts[currentPosition]! + 1;
      } else {
        positionCounts[currentPosition] = 1;
      }
    }

    for (String position in positionCounts.keys) {
      if (positionCounts[position]! >= 3) {
        return true;
      }
    }

    return false;
  }

  bool doesOnlyOneKingExists() {
    int kingsCount = 0;
    for (var element in ChessBoardModel.currentChessBoard()) {
      if (element.piece == Pieces.king) {
        kingsCount++;
      }
    }
    return kingsCount == 1;
  }

  Future<bool> isKingSquareAttacked({
    required PieceType? kingTypeToCheck,
  }) async {
    int opponentKingIndex = ChessBoardModel.getIndexWherePieceAndPieceTypeMatch(
        Pieces.king, kingTypeToCheck);

    PieceType? opponentKingType = kingTypeToCheck;
    Files opponentKingFile = opponentKingIndex.file();
    int opponentKingRank = opponentKingIndex.rank();

    /// -------------------------------------getting surrounding opponent pawns--------------------------
    List<int> surroundingOpponentPawns =
        basicMovesController.getPawnPieces(opponentKingIndex);
    // todo: consider checking the type of the piece inside getPawnPieces
    surroundingOpponentPawns.removeWhere((pawn) => pawn.piece() != Pieces.pawn);
    // pawns can't check a king of the same type
    surroundingOpponentPawns
        .removeWhere((pawn) => pawn.type() == opponentKingType);
    // pawns that are on the same file as the king aren't checking the king
    surroundingOpponentPawns
        .removeWhere((pawn) => pawn.file() == opponentKingFile);
    surroundingOpponentPawns.removeWhere((pawn) {
      // a black king can't be put in check by white pawns higher in rank
      if (opponentKingType == PieceType.dark &&
          pawn.rank() > opponentKingRank) {
        return true;
      }
      // a white king can't be put in check by white pawns lower in rank
      if (opponentKingType == PieceType.light &&
          pawn.rank() < opponentKingRank) {
        return true;
      }
      return false;
    });

    /// -------------------------------------getting surrounding opponent knights---------------
    List<int> surroundingKnights =
        basicMovesController.getKnightPieces(opponentKingIndex);
    // knights of the same type as the opponent king can't check the king
    surroundingKnights
        .removeWhere((knight) => knight.type() == opponentKingType);
    // empty squares don't count, same for pieces that are not knights
    surroundingKnights.removeWhere(
        (square) => square.piece() == null || square.piece() != Pieces.knight);

    /// ------------------------------------getting surrounding opponent rooks and queens  (queens vertical/horizontal to the opponent king)---------
    List<int> surroundingRooksAndQueens = [
      ...basicMovesController.getHorizontalPieces(opponentKingIndex),
      ...basicMovesController.getVerticalPieces(opponentKingIndex),
    ];

    List<int> surroundingRooksAndQueensInLineOfSight =
        await legalMovesController.getLegalMovesOnly(
            legalAndIllegalMoves: surroundingRooksAndQueens,
            from: opponentKingIndex);

    // rooks or queens of the same type as the king can't check the king
    surroundingRooksAndQueensInLineOfSight
        .removeWhere((rookOrQueen) => rookOrQueen.type() == opponentKingType);

    // empty squares don't count, same for pieces that are neither rooks nor queens
    surroundingRooksAndQueensInLineOfSight.removeWhere((square) =>
        square.piece() == null ||
        (square.piece() != Pieces.rook && square.piece() != Pieces.queen));

    /// ----------------------------------------getting surrounding opponent bishops and queens (queens diagonal to the opponent king)----------------
    List<int> surroundingBishopsAndQueens =
        basicMovesController.getDiagonalPieces(opponentKingIndex);

    List<int> surroundingBishopsAndQueensInLineOfSight =
        await legalMovesController.getLegalMovesOnly(
            legalAndIllegalMoves: surroundingBishopsAndQueens,
            from: opponentKingIndex);

    surroundingBishopsAndQueensInLineOfSight.removeWhere(
        (bishopOrQueen) => bishopOrQueen.type() == opponentKingType);
    // empty squares don't count, same for pieces that are neither bishops nor queens
    surroundingBishopsAndQueensInLineOfSight.removeWhere((square) =>
        square.piece() == null ||
        (square.piece() != Pieces.bishop && square.piece() != Pieces.queen));

    ///------------------------------------------------------------------------------------

    return surroundingOpponentPawns.isNotEmpty ||
        surroundingKnights.isNotEmpty ||
        surroundingRooksAndQueensInLineOfSight.isNotEmpty ||
        surroundingBishopsAndQueensInLineOfSight.isNotEmpty;
  }

  Future<bool> isCheckmate({required PlayingTurn playingTurn}) async {
    // If at the end of this function this list is empty then it is a checkmate
    List<int> movesThatProtectTheKing = [];

    // find all the attacked player pieces expect the king
    // find all the legal moves for those pieces
    // move them and check if king is still attacked
    // a late initialization error should not occur, unless the logic is wrong
    late int kingIndex;

    for (int index = 0; index <= 63; index++) {
      if (index.type() == playingTurn.type()) {
        if (index.piece() == Pieces.king) {
          kingIndex = index;
        } else {
          List<int> legalMovesIndices =
              await legalMovesController.getLegalMovesIndices(
            from: index,
          );
          movesThatProtectTheKing.addAll(legalMovesIndices);
        }
      }
    }

    for (var moveIndex in movesThatProtectTheKing.deepCopy()) {
      Pieces? originalPiece = moveIndex.piece();
      PieceType? originalPieceType = moveIndex.type();

      // placing a pawn at moveIndex
      await ChessBoardModel.updateSquareAtIndex(
          moveIndex, Pieces.pawn, playingTurn.type());

      // checking if check remains
      if (await isKingSquareAttacked(kingTypeToCheck: playingTurn.type())) {
        movesThatProtectTheKing.removeWhere((index) => index == moveIndex);
      }

      // resetting the square to its original state
      ChessBoardModel.updateSquareAtIndex(
          moveIndex, originalPiece, originalPieceType);
    }

    ///-----------------------------checking if king can move to safety
    List<int> kingMovesThatWouldProtectHim =
        await legalMovesController.getLegalMovesIndices(from: kingIndex);

    for (var moveIndex in kingMovesThatWouldProtectHim.deepCopy()) {
      // the square we will temporarily move the king to for testing if the check remains.

      Pieces? originalPiece = moveIndex.piece();
      PieceType? originalPieceType = moveIndex.type();
      // emptying the square the king is currently on
      ChessBoardModel.emptySquareAtIndex(kingIndex);

      // moving the king to the new square
      ChessBoardModel.updateSquareAtIndex(
          moveIndex, Pieces.king, playingTurn.type());

      //-----------------------
      if (await isKingSquareAttacked(kingTypeToCheck: playingTurn.type())) {
        kingMovesThatWouldProtectHim.removeWhere((index) => index == moveIndex);
      }
      // resetting the square to its original state
      ChessBoardModel.updateSquareAtIndex(
          moveIndex, originalPiece, originalPieceType);
      // moving the king back to its original square
      ChessBoardModel.updateSquareAtIndex(
          kingIndex, Pieces.king, playingTurn.type());
      //----------------------------------
    }

    return kingMovesThatWouldProtectHim.isEmpty &&
        movesThatProtectTheKing.isEmpty;
  }

  Future<bool> checkForStaleMate(
    PieceType? opponentPlayerType,
  ) async {
    if (SharedState.instance.isKingChecked) {
      return false;
    }
    // checking for stalemate
    List<int> allLegalMovesIndices = [];

    for (int index = 0; index <= 63; index++) {
      if (index.type() == opponentPlayerType) {
        // isKingChecked is false because a king can't be in stalemate and at the same time checked
        List<int> moves = await legalMovesController.getLegalMovesIndices(
            from: index, isKingChecked: false, ignorePlayingTurn: true);
        // had to call filterMovesThatExposeKingToCheck, filterMovesThatCauseTwoAdjacentKings here because passing false to ignorePlayingTurn caused problems
        moves = await LegalMovesController.instance
            .filterMovesThatExposeKingToCheck(moves, index);
        moves = await LegalMovesController.instance
            .filterMovesThatCauseTwoAdjacentKings(moves, index);

        allLegalMovesIndices.addAll(moves);
      }
    }

    return allLegalMovesIndices.isEmpty;
  }
}

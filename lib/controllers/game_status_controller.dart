import 'package:chess/controllers/enums.dart';

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
  static int? checkedKingIndex;
  static bool isKingChecked = false;

  static Future<GameStatusDTO> checkStatus(int to) async {
    PieceType? opponentKingType = to.toPieceType()?.toOppositeType();
    // resetting checkedKingIndex on each new move so that the red check square is removed
    checkedKingIndex = null;
    isKingChecked = await gameStatusController.isKingSquareAttacked(
        attackedKingType: opponentKingType);
    if (isKingChecked) {
      checkedKingIndex = ChessBoardModel.getIndexWherePieceAndPieceTypeMatch(
          Pieces.king, opponentKingType,
          matchPiece: true, matchType: true);

      if (await gameStatusController.isCheckmate(
          playingTurn: opponentKingType!.toPlayingTurn())) {
        helperMethods.preventFurtherInteractions(true);
        callbacks.onVictory(VictoryType.checkmate);
        callbacks.playSound(SoundType.victory);
      }
    }

    if (await gameStatusController.checkForStaleMate(
        opponentPlayerType: opponentKingType!, isKingChecked: isKingChecked)) {
      // todo: uncomment this
      // soundToPlay = SoundType.draw;
    }

    return GameStatusDTO(checkedKingIndex: checkedKingIndex);
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
    required PieceType? attackedKingType,
    int? escapeTo,
  }) async {
    int opponentKingIndex = escapeTo ??
        ChessBoardModel.getIndexWherePieceAndPieceTypeMatch(
            Pieces.king, attackedKingType,
            matchPiece: true, matchType: true);

    PieceType? opponentKingType = attackedKingType;
    Files opponentKingFile = opponentKingIndex.toFile();
    int opponentKingRank = opponentKingIndex.toRank();

    /// -------------------------------------getting surrounding opponent pawns--------------------------
    List<int> surroundingOpponentPawns =
        basicMovesController.getPawnPieces(opponentKingIndex);
    // pawns can't check a king of the same type
    surroundingOpponentPawns
        .removeWhere((pawn) => pawn.toPieceType() == opponentKingType);
    // pawns that are on the same file as the king aren't checking the king
    surroundingOpponentPawns
        .removeWhere((pawn) => pawn.toFile() == opponentKingFile);
    surroundingOpponentPawns.removeWhere((pawn) {
      // a black king can't be put in check by white pawns higher in rank
      if (opponentKingType == PieceType.dark &&
          pawn.toRank() > opponentKingRank) {
        return true;
      }
      // a white king can't be put in check by white pawns lower in rank
      if (opponentKingType == PieceType.light &&
          pawn.toRank() < opponentKingRank) {
        return true;
      }
      return false;
    });

    /// -------------------------------------getting surrounding opponent knights---------------
    List<int> surroundingKnights =
        basicMovesController.getKnightPieces(opponentKingIndex);
    // knights of the same type as the opponent king can't check the king
    surroundingKnights
        .removeWhere((knight) => knight.toPieceType() == opponentKingType);
    // empty squares don't count, same for pieces that are not knights
    surroundingKnights.removeWhere((square) =>
        square.toPiece() == null || square.toPiece() != Pieces.knight);

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
    surroundingRooksAndQueensInLineOfSight.removeWhere(
        (rookOrQueen) => rookOrQueen.toPieceType() == opponentKingType);

    // empty squares don't count, same for pieces that are neither rooks nor queens
    surroundingRooksAndQueensInLineOfSight.removeWhere((square) =>
        square.toPiece() == null ||
        (square.toPiece() != Pieces.rook && square.toPiece() != Pieces.queen));

    /// ----------------------------------------getting surrounding opponent bishops and queens (queens diagonal to the opponent king)----------------
    List<int> surroundingBishopsAndQueens =
        basicMovesController.getDiagonalPieces(opponentKingIndex);

    List<int> surroundingBishopsAndQueensInLineOfSight =
        await legalMovesController.getLegalMovesOnly(
            legalAndIllegalMoves: surroundingBishopsAndQueens,
            from: opponentKingIndex);

    surroundingBishopsAndQueensInLineOfSight.removeWhere(
        (bishopOrQueen) => bishopOrQueen.toPieceType() == opponentKingType);
    // empty squares don't count, same for pieces that are neither bishops nor queens
    surroundingBishopsAndQueensInLineOfSight.removeWhere((square) =>
        square.toPiece() == null ||
        (square.toPiece() != Pieces.bishop &&
            square.toPiece() != Pieces.queen));

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
      if (index.toPieceType() == playingTurn.toPieceType()) {
        if (index.toPiece() == Pieces.king) {
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
      Pieces? originalPiece = moveIndex.toPiece();
      PieceType? originalPieceType = moveIndex.toPieceType();

      // placing a pawn at moveIndex
      await ChessBoardModel.updateSquareAtIndex(
          moveIndex, Pieces.pawn, playingTurn.toPieceType());

      // checking if check remains
      if (await isKingSquareAttacked(
          attackedKingType: playingTurn.toPieceType())) {
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

      Pieces? originalPiece = moveIndex.toPiece();
      PieceType? originalPieceType = moveIndex.toPieceType();
      // emptying the square the king is currently on
      ChessBoardModel.emptySquareAtIndex(kingIndex);

      // moving the king to the new square
      ChessBoardModel.updateSquareAtIndex(
          moveIndex, Pieces.king, playingTurn.toPieceType());

      // await Future.delayed(Duration(seconds: 1));
      // callbacks.updateView();
      //-----------------------
      if (await isKingSquareAttacked(
          attackedKingType: playingTurn.toPieceType())) {
        kingMovesThatWouldProtectHim.removeWhere((index) => index == moveIndex);
      }
      // resetting the square to its original state
      ChessBoardModel.updateSquareAtIndex(
          moveIndex, originalPiece, originalPieceType);
      // moving the king back to its original square
      ChessBoardModel.updateSquareAtIndex(
          kingIndex, Pieces.king, playingTurn.toPieceType());
      //----------------------------------
    }

    return kingMovesThatWouldProtectHim.isEmpty &&
        movesThatProtectTheKing.isEmpty;
  }

  Future<bool> checkForStaleMate(
      {required PieceType opponentPlayerType,
      required bool isKingChecked}) async {
    // checking for stalemate
    List<int> allLegalMovesIndices = [];

    for (int index = 0; index <= 63; index++) {
      if (index.toPieceType() == opponentPlayerType) {
        List<int> moves = await legalMovesController.getLegalMovesIndices(
            from: index, isKingChecked: isKingChecked, ignorePlayingTurn: true);
        allLegalMovesIndices.addAll(moves);
      }
    }
    // player has no legal move and an empty square was not tapped
    if (allLegalMovesIndices.isEmpty) {
      helperMethods.preventFurtherInteractions(true);
      callbacks.onDraw(DrawType.stalemate);
      return true;
    }
    return false;
  }
}

class GameStatusDTO {
  final int? checkedKingIndex;

  GameStatusDTO({required this.checkedKingIndex});
}

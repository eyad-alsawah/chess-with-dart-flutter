import 'package:chess/controllers/enums.dart';
import 'package:chess/controllers/shared_state.dart';
import 'package:chess/model/move.dart';
import 'package:chess/model/square.dart';
import 'package:chess/utils/extensions.dart';

class ChessBoardModel {
  static Square emptySquare = Square(piece: null, pieceType: null);
  static Map<ChessSquare, Square> chessBoard = {
    // -------------------------------First Rank------------------
    ChessSquare.a1: Square(piece: Pieces.rook, pieceType: PieceType.light),
    ChessSquare.b1: Square(piece: Pieces.knight, pieceType: PieceType.light),
    ChessSquare.c1: Square(piece: Pieces.bishop, pieceType: PieceType.light),
    ChessSquare.d1: Square(piece: Pieces.queen, pieceType: PieceType.light),
    ChessSquare.e1: Square(piece: Pieces.king, pieceType: PieceType.light),
    ChessSquare.f1: Square(piece: Pieces.bishop, pieceType: PieceType.light),
    ChessSquare.g1: Square(piece: Pieces.knight, pieceType: PieceType.light),
    ChessSquare.h1: Square(piece: Pieces.rook, pieceType: PieceType.light),
    // -------------------------------Second Rank------------------
    ChessSquare.a2: Square(piece: Pieces.pawn, pieceType: PieceType.light),
    ChessSquare.b2: Square(piece: Pieces.pawn, pieceType: PieceType.light),
    ChessSquare.c2: Square(piece: Pieces.pawn, pieceType: PieceType.light),
    ChessSquare.d2: Square(piece: Pieces.pawn, pieceType: PieceType.light),
    ChessSquare.e2: Square(piece: Pieces.pawn, pieceType: PieceType.light),
    ChessSquare.f2: Square(piece: Pieces.pawn, pieceType: PieceType.light),
    ChessSquare.g2: Square(piece: Pieces.pawn, pieceType: PieceType.light),
    ChessSquare.h2: Square(piece: Pieces.pawn, pieceType: PieceType.light),
    // -------------------------------Third Rank------------------
    ChessSquare.a3: emptySquare,
    ChessSquare.b3: emptySquare,
    ChessSquare.c3: emptySquare,
    ChessSquare.d3: emptySquare,
    ChessSquare.e3: emptySquare,
    ChessSquare.f3: emptySquare,
    ChessSquare.g3: emptySquare,
    ChessSquare.h3: emptySquare,
    // -------------------------------Fourth Rank------------------
    ChessSquare.a4: emptySquare,
    ChessSquare.b4: emptySquare,
    ChessSquare.c4: emptySquare,
    ChessSquare.d4: emptySquare,
    ChessSquare.e4: emptySquare,
    ChessSquare.f4: emptySquare,
    ChessSquare.g4: emptySquare,
    ChessSquare.h4: emptySquare,
    // -------------------------------Fifth Rank------------------
    ChessSquare.a5: emptySquare,
    ChessSquare.b5: emptySquare,
    ChessSquare.c5: emptySquare,
    ChessSquare.d5: emptySquare,
    ChessSquare.e5: emptySquare,
    ChessSquare.f5: emptySquare,
    ChessSquare.g5: emptySquare,
    ChessSquare.h5: emptySquare,
    // -------------------------------Sixth Rank------------------
    ChessSquare.a6: emptySquare,
    ChessSquare.b6: emptySquare,
    ChessSquare.c6: emptySquare,
    ChessSquare.d6: emptySquare,
    ChessSquare.e6: emptySquare,
    ChessSquare.f6: emptySquare,
    ChessSquare.g6: emptySquare,
    ChessSquare.h6: emptySquare,
    // -------------------------------Seventh Rank------------------
    ChessSquare.a7: Square(piece: Pieces.pawn, pieceType: PieceType.dark),
    ChessSquare.b7: Square(piece: Pieces.pawn, pieceType: PieceType.dark),
    ChessSquare.c7: Square(piece: Pieces.pawn, pieceType: PieceType.dark),
    ChessSquare.d7: Square(piece: Pieces.pawn, pieceType: PieceType.dark),
    ChessSquare.e7: Square(piece: Pieces.pawn, pieceType: PieceType.dark),
    ChessSquare.f7: Square(piece: Pieces.pawn, pieceType: PieceType.dark),
    ChessSquare.g7: Square(piece: Pieces.pawn, pieceType: PieceType.dark),
    ChessSquare.h7: Square(piece: Pieces.pawn, pieceType: PieceType.dark),
    // -------------------------------Eigth Rank------------------
    ChessSquare.a8: Square(piece: Pieces.rook, pieceType: PieceType.dark),
    ChessSquare.b8: Square(piece: Pieces.knight, pieceType: PieceType.dark),
    ChessSquare.c8: Square(piece: Pieces.bishop, pieceType: PieceType.dark),
    ChessSquare.d8: Square(piece: Pieces.queen, pieceType: PieceType.dark),
    ChessSquare.e8: Square(piece: Pieces.king, pieceType: PieceType.dark),
    ChessSquare.f8: Square(piece: Pieces.bishop, pieceType: PieceType.dark),
    ChessSquare.g8: Square(piece: Pieces.knight, pieceType: PieceType.dark),
    ChessSquare.h8: Square(piece: Pieces.rook, pieceType: PieceType.dark),
  };

  static List<Square> currentChessBoard() {
    List<Square> currentBoard = [];
    chessBoard.forEach((key, value) {
      currentBoard.add(value.copy());
    });

    return currentBoard;
  }

  static Future<void> clearBoard() async {
    chessBoard.clear();
  }

  static Future<void> addAll(List<Square> squares) async {
    squares.asMap().forEach((index, value) {
      chessBoard[ChessSquare.values[index]] = value;
    });
  }

  static int getIndexOfSquare(Square square) {
    return chessBoard.entries
        .firstWhere((element) => element.value == square)
        .key
        .index;
  }

  static int getIndexOfSquareAtFileAndRank(
      {required Files file, required int rank}) {
    return chessBoard.entries
        .firstWhere((element) =>
            element.key.rank() == rank && element.key.file() == file)
        .key
        .index;
  }

  static int getIndexWherePieceAndPieceTypeMatch(
    Pieces? piece,
    PieceType? type,
  ) {
    return chessBoard.entries
        .firstWhere((entry) =>
            entry.value.piece == piece && entry.value.pieceType == type)
        .key
        .index;
  }

  //----------------------
  static Future<void> updateSquareAtIndex(
    int index,
    Pieces? piece,
    PieceType? type,
  ) async {
    chessBoard.update(ChessSquare.values[index],
        (value) => Square(piece: piece, pieceType: type));
  }

  static Future<void> emptySquareAtIndex(int index) async {
    chessBoard.update(ChessSquare.values[index],
        (value) => Square(piece: null, pieceType: null));
  }

  //-----------------------------
  static Future<void> executeMove(
      {required int from,
      required int to,
      Pieces? pawnPromotionType,
      Move? rookCastlingMove}) async {
    PieceType? type = from.type();
    Pieces? piece = from.piece();
    emptySquareAtIndex(from);
    updateSquareAtIndex(to, pawnPromotionType ?? piece, type);
    if (rookCastlingMove != null) {
      await executeMove(from: rookCastlingMove.from, to: rookCastlingMove.to);
    }
  }

  static String toFen(
      {required String activeColor,
      required String enPassantTargetSquare,
      required String castlingRights,
      required int halfMoveClock,
      required int fullMoveNumber}) {
    String fen = '';
    List<String> piecesPlacementOnRanks = [];
    //----------------------------------------------------------------------
    int emptySquares = 0;

    for (int i = 0; i <= 63; i++) {
      Square? square = ChessSquare.values[i].index.square();
      Pieces? piece = square.piece;
      PieceType? type = square.pieceType;
      bool isLight = type == PieceType.light;

      if (piece != null && emptySquares != 0) {
        fen += emptySquares.toString();
        emptySquares = 0;
      }

      switch (piece) {
        case Pieces.rook:
          fen += isLight ? 'R' : 'r';
          break;
        case Pieces.knight:
          fen += isLight ? 'N' : 'n';
          break;
        case Pieces.bishop:
          fen += isLight ? 'B' : 'b';
          break;
        case Pieces.queen:
          fen += isLight ? 'Q' : 'q';
          break;
        case Pieces.king:
          fen += isLight ? 'K' : 'k';
          break;
        case Pieces.pawn:
          fen += isLight ? 'P' : 'p';
          break;
        default:
          emptySquares++;
          break;
      }

      if ([
        ChessSquare.h1,
        ChessSquare.h2,
        ChessSquare.h3,
        ChessSquare.h4,
        ChessSquare.h5,
        ChessSquare.h6,
        ChessSquare.h7,
        ChessSquare.h8,
      ].any((e) => e.index == i)) {
        if (emptySquares != 0) {
          fen += emptySquares.toString();
        }
        emptySquares = 0;
        piecesPlacementOnRanks.add(fen);
        fen = '';
      }
    }

    return '${piecesPlacementOnRanks.reversed.join('/')} $activeColor $castlingRights $enPassantTargetSquare $halfMoveClock $fullMoveNumber';
  }

  static void fromFen(String fen) {
    SharedState.instance.activeColor =
        RegExp(r'\b(w|b)\b').firstMatch(fen)!.group(1)!;
    SharedState.instance.castlingRights =
        RegExp(r'^\S+\s\S+\s([KQkq-]+)\s').firstMatch(fen)!.group(1)!;
    SharedState.instance.enPassantTargetSquare =
        RegExp(r'^\S+\s\S+\s\S+\s(\S+)\s').firstMatch(fen)!.group(1)!;
    SharedState.instance.halfMoveClock = int.parse(
        RegExp(r'^\S+\s\S+\s\S+\s\S+\s(\d+)\s').firstMatch(fen)!.group(1)!);
    SharedState.instance.fullMoveNumber = int.parse(
        RegExp(r'^\S+\s\S+\s\S+\s\S+\s\d+\s(\d+)$').firstMatch(fen)!.group(1)!);
    //---------------------------------------------
    List<Square> chessBoardList = [];
    // Corrected regex pattern
    String? piecesPlacement = RegExp(r'^[^\s]*').stringMatch(fen);

    List<String> piecesPlacementOnRanks = piecesPlacement?.split('/') ?? [];

    for (var rank in piecesPlacementOnRanks.reversed) {
      for (var char in rank.split('')) {
        bool isNumber = int.tryParse(char) != null;
        if (isNumber) {
          for (int i = 1; i <= int.tryParse(char)!; i++) {
            chessBoardList.add(Square(piece: null, pieceType: null));
          }
        } else if (char != '/') {
          switch (char) {
            case 'r':
              chessBoardList
                  .add(Square(piece: Pieces.rook, pieceType: PieceType.dark));
              break;
            case 'n':
              chessBoardList
                  .add(Square(piece: Pieces.knight, pieceType: PieceType.dark));
              break;
            case 'b':
              chessBoardList
                  .add(Square(piece: Pieces.bishop, pieceType: PieceType.dark));
              break;
            case 'q':
              chessBoardList
                  .add(Square(piece: Pieces.queen, pieceType: PieceType.dark));
              break;
            case 'k':
              chessBoardList
                  .add(Square(piece: Pieces.king, pieceType: PieceType.dark));
              break;
            case 'p':
              chessBoardList
                  .add(Square(piece: Pieces.pawn, pieceType: PieceType.dark));
              break;
            case 'R':
              chessBoardList
                  .add(Square(piece: Pieces.rook, pieceType: PieceType.light));
              break;
            case 'N':
              chessBoardList.add(
                  Square(piece: Pieces.knight, pieceType: PieceType.light));
              break;
            case 'B':
              chessBoardList.add(
                  Square(piece: Pieces.bishop, pieceType: PieceType.light));
              break;
            case 'Q':
              chessBoardList
                  .add(Square(piece: Pieces.queen, pieceType: PieceType.light));
              break;
            case 'K':
              chessBoardList
                  .add(Square(piece: Pieces.king, pieceType: PieceType.light));
              break;
            case 'P':
              chessBoardList
                  .add(Square(piece: Pieces.pawn, pieceType: PieceType.light));
              break;
            default:
              throw 'fromFen: default case reached for $char';
          }
        }
      }
    }

    for (var i = 0; i <= 63; i++) {
      chessBoard[ChessSquare.values[i]] = chessBoardList[i];
    }

    // Cleanup-------------------------:
    SharedState.instance.legalMovesIndices.clear();
    SharedState.instance.debugHighlightIndices.clear();
    SharedState.instance.selectedPieceIndex = null;
    SharedState.instance.lockFurtherInteractions = false;
    //------------------game_view-----------
    SharedState.instance.squareName = "";
    SharedState.instance.selectedIndex = null;
    //------------------------------------
    SharedState.instance.checkedKingIndex = null;
    SharedState.instance.isKingChecked = false;
    //---------------------------------
  }
}

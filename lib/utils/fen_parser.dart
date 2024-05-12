import 'package:chess/controllers/enums.dart';
import 'package:chess/model/square.dart';

// Note: This Dart code is based on the FEN parser originally implemented in Python by gisraptor.
// Original Python code: https://github.com/gisraptor/fen-parser/blob/master/fen.py
class FenParser {
  static List<Square> generateChessBoard(String fen) {
    List<Square> chessBoard = [];
    Position p = Position(fen);

    // Helper function to convert piece notation to the appropriate Piece enum
    Pieces? getPiece(String piece) {
      switch (piece.toUpperCase()) {
        case 'P':
          return Pieces.pawn;
        case 'R':
          return Pieces.rook;
        case 'N':
          return Pieces.knight;
        case 'B':
          return Pieces.bishop;
        case 'Q':
          return Pieces.queen;
        case 'K':
          return Pieces.king;
        default:
          return null;
      }
    }

    // Reverse the order of the board list
    p.board = p.board.reversed.toList();

    // Iterate over each square on the board and create a Square object
    for (int rank = 1; rank <= 8; rank++) {
      for (int file = 1; file <= 8; file++) {
        String piece = p.board[rank - 1][file - 1];
        PieceType? pieceType = piece.isNotEmpty
            ? (piece == piece.toUpperCase() ? PieceType.light : PieceType.dark)
            : null;
        chessBoard.add(Square(
          file: Files.values[file - 1],
          rank: rank,
          piece: getPiece(piece),
          pieceType: getPiece(piece) != null
              ? pieceType
              : null, // pieceType will be null for empty squares
        ));
      }
    }

    return chessBoard;
  }
}

class Position {
  static const rankTranslation = {
    'a': 0,
    'b': 1,
    'c': 2,
    'd': 3,
    'e': 4,
    'f': 5,
    'g': 6,
    'h': 7,
  };

  static const algebraicTranslation = {
    0: 'a',
    1: 'b',
    2: 'c',
    3: 'd',
    4: 'e',
    5: 'f',
    6: 'g',
    7: 'h',
  };

  List<String> board = [];
  String active = '';
  String castlingAvailability = '';
  String enPassant = '';
  int? halfmoveClock;
  int? fullmoveNumber;
  String fen = '';

  Position(this.fen) {
    RegExp castleValidator = RegExp(r'^[KQkq-]+$');
    RegExp enPassantValidator = RegExp(r'^[a-h1-8-]+$');
    List<String> fenParts = fen.split(' ');
    if (fenParts.length != 6) {
      throw ArgumentError(
          'FEN must be a string with six space-delimited fields');
    }
    String placement = fenParts[0];
    active = fenParts[1];
    castlingAvailability = fenParts[2];
    enPassant = fenParts[3];
    halfmoveClock = int.tryParse(fenParts[4]);
    fullmoveNumber = int.tryParse(fenParts[5]);

    if (placement.isEmpty) {
      throw ArgumentError('Invalid FEN placement string: $placement');
    }
    board = _buildBoard(placement);

    if (!(active == 'w' || active == 'b')) {
      throw ArgumentError('Invalid active color: $active');
    }
    if (!castleValidator.hasMatch(castlingAvailability)) {
      throw ArgumentError(
          'Invalid castling availability: $castlingAvailability');
    }
    if (!enPassantValidator.hasMatch(enPassant)) {
      throw ArgumentError('Invalid en passant target: $enPassant');
    }
    if (halfmoveClock == null) {
      throw ArgumentError(
          'The half move clock is not an integer: ${fenParts[4]}');
    }
    if (fullmoveNumber == null) {
      throw ArgumentError(
          'The full move number is not an integer: ${fenParts[5]}');
    }
  }

  List<String> _buildBoard(String placement) {
    RegExp validator = RegExp(r'^[RrNnBbQqKkPp1-8/]+$');
    Match? match = validator.firstMatch(placement);
    if (match == null) {
      throw ArgumentError('Invalid FEN placement string: $placement');
    }
    Map<String, String> expander = {
      '1': ' ',
      '2': ' ' * 2,
      '3': ' ' * 3,
      '4': ' ' * 4,
      '5': ' ' * 5,
      '6': ' ' * 6,
      '7': ' ' * 7,
      '8': ' ' * 8,
    };
    String expansion =
        placement.split('').map((ch) => expander[ch] ?? ch).join('');
    return expansion.split('/');
  }

  @override
  String toString() {
    return _renderAsciiBoard();
  }

  String _renderAsciiBoard() {
    String renderedBoard = '';
    for (int i = 0; i < board.length; i++) {
      renderedBoard += ' ${8 - i} | ${board[i].split('').join(' | ')} |\n';
      renderedBoard += '   |-----------------------|\n';
    }
    renderedBoard += '     a   b   c   d   e   f   g   h \n';
    return renderedBoard;
  }

  Position movePiece(String move) {
    Position newPosition = Position(fen);
    newPosition._currentRank = rankTranslation[move[0]]!;
    newPosition._currentFile = 8 - int.parse(move[1]);
    newPosition._newRank = rankTranslation[move[2]]!;
    newPosition._newFile = 8 - int.parse(move[3]);
    newPosition._setPieceMoved();
    newPosition._setCapture();
    newPosition._setEnPassant();
    newPosition._setCastling();
    newPosition._setActive();
    newPosition._setFullmoveNumber();
    newPosition._setHalfmoveClock();
    newPosition._executeMove();
    newPosition._constructUpdatedFen();
    return newPosition;
  }

  int? _currentRank;
  int? _currentFile;
  int? _newRank;
  int? _newFile;
  late String _pieceMoved;
  late String _pieceCaptured;
  late bool _capture;

  void _setPieceMoved() {
    _pieceMoved = board[_currentFile!][_currentRank!];
    if (active == 'w' && !_pieceMoved.toUpperCase().contains(_pieceMoved) ||
        active == 'b' && !_pieceMoved.toLowerCase().contains(_pieceMoved)) {
      throw ArgumentError('The piece being moved is not the correct color.');
    }
  }

  void _setCapture() {
    _pieceCaptured = board[_newFile!][_newRank!];
    _capture = _pieceCaptured != ' ';
    if (active == 'w' &&
            _pieceCaptured.toUpperCase().contains(_pieceCaptured) ||
        active == 'b' &&
            _pieceCaptured.toLowerCase().contains(_pieceCaptured)) {
      throw ArgumentError('The piece being captured is not the correct color.');
    }
  }

  void _setEnPassant() {
    if (_pieceMoved.contains('Pp')) {
      if (active == 'w' &&
          _currentFile! - _newFile! == 2 &&
          _newRank! == _currentRank) {
        enPassant = '${algebraicTranslation[_newRank!]!}${8 - (_newFile! + 1)}';
      } else if (active == 'b' &&
          _newFile! - _currentFile! == 2 &&
          _newRank! == _currentRank) {
        enPassant = '${algebraicTranslation[_newRank!]!}${8 - (_newFile! - 1)}';
      }
    } else {
      enPassant = '-';
    }
  }

  void _setCastling() {
    if (_pieceMoved.contains('Kk')) {
      if (_pieceMoved.contains('K')) {
        castlingAvailability =
            castlingAvailability.replaceAll(RegExp(r'[KQ]+'), '');
      } else if (_pieceMoved.contains('k')) {
        castlingAvailability =
            castlingAvailability.replaceAll(RegExp(r'[kq]+'), '');
      }
    } else if (_pieceMoved.contains('Rr')) {
      String removeExp = '';
      if (_pieceMoved.contains('R')) {
        if (_currentRank == 0) {
          removeExp = 'Q';
        } else if (_currentRank == 8) {
          removeExp = 'K';
        }
      } else if (_pieceMoved.contains('r')) {
        if (_currentRank == 0) {
          removeExp = 'q';
        } else if (_currentRank == 8) {
          removeExp = 'k';
        }
      }
      castlingAvailability = castlingAvailability.replaceAll(removeExp, '');
    }
    if (castlingAvailability.isEmpty) {
      castlingAvailability = '-';
    }
  }

  void _setActive() {
    active = active == 'w' ? 'b' : 'w';
  }

  void _setFullmoveNumber() {
    if (active == 'w') {
      fullmoveNumber = fullmoveNumber! + 1;
    }
  }

  void _setHalfmoveClock() {
    if (_pieceMoved.contains('Pp') || _capture) {
      halfmoveClock = 0;
    } else {
      halfmoveClock = (halfmoveClock ?? 0) + 1;
    }
  }

  void _executeMove() {
    List<String> fromFile = board[_currentFile!].split('');
    fromFile[_currentRank!] = ' ';
    board[_currentFile!] = fromFile.join('');
    List<String> toFile = board[_newFile!].split('');
    toFile[_newRank!] = _pieceMoved;
    board[_newFile!] = toFile.join('');
    if (_pieceMoved.contains('Kk')) {
      if ((_currentRank! - _newRank!).abs() == 2) {
        List<String> rookFile = board[_currentFile!].split('');
        int rookCurrentRank;
        int rookNewRank;
        if (_currentRank! > _newRank!) {
          rookCurrentRank = 0;
          rookNewRank = 3;
        } else {
          rookCurrentRank = 7;
          rookNewRank = 5;
        }
        rookFile[rookCurrentRank] = ' ';
        String rookPiece = 'R';
        if (_pieceMoved.contains('k')) {
          rookPiece = 'r';
        }
        rookFile[rookNewRank] = rookPiece;
        board[_currentFile!] = rookFile.join('');
      }
    }
  }

  void _constructUpdatedFen() {
    String boardString = board.join('/');
    boardString = boardString.replaceAllMapped(
        RegExp(r'( +)'), (match) => '${match.group(0)!.length}');
    fen =
        '$boardString $active $castlingAvailability $enPassant $halfmoveClock $fullmoveNumber';
  }
}

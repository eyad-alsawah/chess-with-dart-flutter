enum RelativeDirection {
  rankLeft,
  rankRight,
  fileTop,
  fileBottom,
  diagonalTopLeft,
  diagonalTopRight,
  diagonalBottomLeft,
  diagonalBottomRight,
  undefined
}

enum GameOutcome {
  victory,
  draw,
}

enum VictoryType {
  checkmate,
  timeout,
  resignation,
}

enum DrawType {
  insufficientMaterial,
  stalemate,
  fiftyMoveRule,
  mutualAgreement,
  threeFoldRepetition
}

enum CastlingType { kingSide, queenSide }

enum PlayingTurn { white, black }

enum PieceType { light, dark }

enum Files { a, b, c, d, e, f, g, h }

enum Pieces {
  rook,
  knight,
  bishop,
  queen,
  king,
  pawn,
}

enum SoundType {
  pieceMoved,
  capture,
  kingChecked,
  victory,
  draw,
  illegal,
}

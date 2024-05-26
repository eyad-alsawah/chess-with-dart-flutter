String castlingRights = 'KQkq';
void main() {
  updateCastlingRights(lightKingMoved: true);
  updateCastlingRights(lightKingSideRookMoved: true);
  print("castlingRights: $castlingRights");
}

void updateCastlingRights(
    {bool lightKingSideRookMoved = false,
    bool lightQueenSideRookMoved = false,
    bool darkKingSideRookMoved = false,
    bool darkQueenSideRookMoved = false,
    bool lightKingMoved = false,
    bool darkKingMoved = false}) {
  if (lightKingSideRookMoved) {
    castlingRights = castlingRights.replaceAll('K', '');
  } else if (lightQueenSideRookMoved) {
    castlingRights = castlingRights.replaceAll('Q', '');
  } else if (darkKingSideRookMoved) {
    castlingRights = castlingRights.replaceAll('k', '');
  } else if (darkQueenSideRookMoved) {
    castlingRights = castlingRights.replaceAll('q', '');
  } else if (lightKingMoved) {
    castlingRights = castlingRights.replaceAll(RegExp('[A-Z]'), '');
  } else if (darkKingMoved) {
    castlingRights = castlingRights.replaceAll(RegExp('[a-z]'), '');
  }

  if (castlingRights.isEmpty) {
    castlingRights = '-';
  }
}

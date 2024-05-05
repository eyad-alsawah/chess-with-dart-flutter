extension ListDeepCopy<T> on List<T> {
  List<T> deepCopy() {
    return map((element) {
      if (element is List) {
        return element.deepCopy() as T; // Recursively deep copy nested lists
      } else if (element is Map) {
        return element.map((key, value) => MapEntry(key, value.deepCopy()))
            as T; // Deep copy maps
      } else if (element is Set) {
        return element.map((value) => value.deepCopy()).toSet()
            as T; // Deep copy elements in sets
      } else {
        return element; // Return other types as is
      }
    }).toList();
  }
}

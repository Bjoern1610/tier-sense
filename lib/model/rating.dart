/// This class implements the rating functionality.
class Rating {
  List<String> _nopes;
  List<String> _supers;
  List<String> _likes;

  /// Creates a new Rating object.
  Rating() {
    _nopes = [];
    _supers = [];
    _likes = [];
  }

  /// Returns the [nopes] which were defined by the user's swipe gestures.
  List<String> get nopes => List.unmodifiable(_nopes);

  /// Adds another [nope] to the [nopes].
  void addNope(String nope) {
    if (!_nopes.contains(nope)) {
      _nopes.add(nope);
    }
  }

  /// Returns the [supers] which were defined by the user's swipe gestures.
  List<String> get supers => List.unmodifiable(_supers);

  /// Adds another [superLike] to the [supers].
  void addSuper(String superLike) {
    if (!_supers.contains(superLike)) {
      _supers.add(superLike);
    }
  }

  /// Returns the [likes] which were defined by the user's swipe gestures.
  List<String> get likes => List.unmodifiable(_likes);

  /// Adds another [like] to the [likes].
  void addLike(String like) {
    if (!_likes.contains(like)) {
      _likes.add(like);
    }
  }
}

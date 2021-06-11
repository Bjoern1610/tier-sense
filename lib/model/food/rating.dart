class Rating {

  List<String> _nopes;
  List<String> _supers;
  List<String> _likes;

  Rating() {
    _nopes = [];
    _supers = [];
    _likes = [];
  }

  List<String> get nopes => List.unmodifiable(_nopes);

  void addNope(String nope) {
    if (!_nopes.contains(nope)) {
      _nopes.add(nope);
    }
  }

  List<String> get supers => List.unmodifiable(_supers);

  void addSuper(String superLike) {
    if (!_supers.contains(superLike)) {
      _supers.add(superLike);
    }
  }

  List<String> get likes => List.unmodifiable(_likes);

  void addLike(String like) {
    if (!_likes.contains(like)) {
      _likes.add(like);
    }
  }
}
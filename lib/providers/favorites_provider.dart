import 'package:flutter/foundation.dart';

class FavoritesProvider extends ChangeNotifier {
  // Set otomatis mencegah data duplikat (menggunakan ID destinasi yang ada di Supabase: 1 = Pantai Kuta, 7 = Gunung Agung)
  final Set<int> _ids = {1, 7};

  Set<int> get ids => Set.unmodifiable(_ids);
  int get count => _ids.length;

  bool isFavorite(int id) => _ids.contains(id);

  /// Mengembalikan true jika sekarang menjadi favorit.
  bool toggle(int id) {
    final added = _ids.add(id);
    if (!added) _ids.remove(id);
    notifyListeners();
    return added;
  }

  void remove(int id) {
    if (_ids.remove(id)) notifyListeners();
  }

  void clear() {
    _ids.clear();
    notifyListeners();
  }
}

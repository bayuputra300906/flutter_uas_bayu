import 'package:flutter/foundation.dart';

class FavoritesProvider extends ChangeNotifier {
  // Set otomatis mencegah data duplikat.
  final Set<int> _ids = {1, 3}; // Inisialisasi awal dengan destinasi favorit

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

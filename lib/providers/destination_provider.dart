import 'package:flutter/foundation.dart';

import '../models/destination.dart';
import '../repositories/destination_repository.dart';

enum LoadStatus { initial, loading, success, error }

class DestinationProvider extends ChangeNotifier {
  DestinationProvider(this._repository);

  final DestinationRepository _repository;

  LoadStatus _status = LoadStatus.initial;
  List<Destination> _items = [];
  String? _error;
  String _query = '';
  String _category = 'Semua';
  String _sortBy = 'Popular';

  LoadStatus get status => _status;
  List<Destination> get items => _items;
  String? get error => _error;
  String get query => _query;
  String get category => _category;
  String get sortBy => _sortBy;

  List<Destination> get filtered {
    final q = _query.trim().toLowerCase();
    var list = _items.where((d) {
      final matchCategory = _category == 'Semua' ||
          d.category.toLowerCase() == _category.toLowerCase();
      final matchQuery = q.isEmpty ||
          d.name.toLowerCase().contains(q) ||
          d.location.toLowerCase().contains(q) ||
          d.description.toLowerCase().contains(q);
      return matchCategory && matchQuery;
    }).toList();

    switch (_sortBy) {
      case 'Rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Harga Terendah':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Harga Tertinggi':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Nama':
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Popular':
      default:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return list;
  }

  List<Destination> get popular {
    final sorted = [..._items]..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(6).toList();
  }

  List<Destination> get nearby {
    return _items.where((d) => d.location.contains('Nusa') || d.location.contains('Badung') || d.location.contains('Tabanan')).take(5).toList();
  }

  Destination? byId(int id) => _items.where((d) => d.id == id).firstOrNull;

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setCategory(String value) {
    _category = value;
    notifyListeners();
  }

  void setSortBy(String value) {
    _sortBy = value;
    notifyListeners();
  }

  void resetFilters() {
    _query = '';
    _category = 'Semua';
    _sortBy = 'Popular';
    notifyListeners();
  }

  Future<void> load() async {
    _status = LoadStatus.loading;
    _error = null;
    notifyListeners();
    try {
      _items = await _repository.getDestinations();
      _status = LoadStatus.success;
    } catch (e) {
      _error = e.toString();
      _status = LoadStatus.error;
    }
    notifyListeners();
  }

  Future<String?> add(Destination d) async {
    try {
      final created = await _repository.addDestination(d);
      _items = [created, ..._items];
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> update(Destination d) async {
    try {
      final updated = await _repository.updateDestination(d);
      _items = _items.map((x) => x.id == updated.id ? updated : x).toList();
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> remove(int id) async {
    try {
      await _repository.deleteDestination(id);
      _items = _items.where((x) => x.id != id).toList();
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}

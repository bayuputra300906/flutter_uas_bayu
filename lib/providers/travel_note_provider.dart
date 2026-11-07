import 'package:flutter/foundation.dart';

import '../models/travel_note.dart';
import '../repositories/travel_note_repository.dart';

enum NoteStatus { initial, loading, success, error }

class TravelNoteProvider extends ChangeNotifier {
  TravelNoteProvider(this._repository);

  final TravelNoteRepository _repository;

  NoteStatus _status = NoteStatus.initial;
  List<TravelNote> _items = [];
  String? _error;

  NoteStatus get status => _status;
  List<TravelNote> get items => _items;
  String? get error => _error;
  int get count => _items.length;

  List<TravelNote> notesForDestination(int destinationId) {
    return _items.where((n) => n.destinationId == destinationId).toList();
  }

  Future<void> load() async {
    _status = NoteStatus.loading;
    _error = null;
    notifyListeners();
    try {
      _items = await _repository.getNotes();
      _status = NoteStatus.success;
    } catch (e) {
      _error = e.toString();
      _status = NoteStatus.error;
    }
    notifyListeners();
  }

  Future<String?> addNote(TravelNote note) async {
    try {
      final created = await _repository.addNote(note);
      _items = [created, ..._items];
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateNote(TravelNote note) async {
    try {
      final updated = await _repository.updateNote(note);
      final index = _items.indexWhere((n) => n.id == updated.id);
      if (index != -1) {
        _items[index] = updated;
        notifyListeners();
      }
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteNote(int id) async {
    try {
      await _repository.deleteNote(id);
      _items.removeWhere((n) => n.id == id);
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}

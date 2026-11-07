import '../models/travel_note.dart';
import '../services/travel_note_service.dart';

class TravelNoteRepository {
  TravelNoteRepository(this._service);

  final TravelNoteService _service;

  Future<List<TravelNote>> getNotes() => _service.getAll();

  Future<TravelNote> addNote(TravelNote note) => _service.create(note);

  Future<TravelNote> updateNote(TravelNote note) => _service.update(note);

  Future<void> deleteNote(int id) => _service.delete(id);
}

import 'dart:async';

import '../models/travel_note.dart';

class TravelNoteService {
  // Database in-memory dengan data awal realistis untuk TravelBuddy
  final List<TravelNote> _notes = [
    const TravelNote(
      id: 1,
      destinationId: 1,
      destinationName: 'Kelingking Beach',
      note: 'Wajib sewa boat pagi jam 07:00 dari Sanur ke Nusa Penida. Jangan lupa bawa kamera waterproof dan sunscreen!',
      rating: 5.0,
      visitDate: '2026-12-15',
      isVisited: true,
      createdAt: '2026-11-01',
    ),
    const TravelNote(
      id: 2,
      destinationId: 3,
      destinationName: 'Gunung Batur Kintamani',
      note: 'Rencana sunrise trekking bareng teman PTI 5A. Berangkat dari Ubud jam 02:30 pagi.',
      rating: 4.8,
      visitDate: '2026-12-20',
      isVisited: false,
      createdAt: '2026-11-02',
    ),
  ];

  int _nextId = 3;

  Future<List<TravelNote>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List<TravelNote>.from(_notes);
  }

  Future<TravelNote> create(TravelNote note) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final newNote = note.copyWith(
      id: _nextId++,
      createdAt: DateTime.now().toIso8601String().substring(0, 10),
    );
    _notes.insert(0, newNote);
    return newNote;
  }

  Future<TravelNote> update(TravelNote note) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index == -1) {
      throw Exception('Catatan perjalanan tidak ditemukan.');
    }
    _notes[index] = note;
    return note;
  }

  Future<void> delete(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _notes.removeWhere((n) => n.id == id);
  }
}

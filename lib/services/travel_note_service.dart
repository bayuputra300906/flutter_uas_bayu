import 'dart:async';

import '../models/travel_note.dart';

class TravelNoteService {
  // Database catatan rencana perjalanan - disinkronkan dengan data destinasi asli di Supabase
  final List<TravelNote> _notes = [
    const TravelNote(
      id: 1,
      destinationId: 1,
      destinationName: 'Pantai Kuta',
      note: 'Menikmati matahari terbenam (sunset) di Pantai Kuta sore hari jam 17:30 bersama teman.',
      rating: 5.0,
      visitDate: '2026-12-15',
      isVisited: true,
      createdAt: '2026-11-01',
    ),
    const TravelNote(
      id: 2,
      destinationId: 7,
      destinationName: 'Gunung Agung',
      note: 'Rencana sunrise trekking pagi hari ke Gunung Agung Karangasem.',
      rating: 4.8,
      visitDate: '2026-12-20',
      isVisited: false,
      createdAt: '2026-11-02',
    ),
  ];

  int _nextId = 3;

  Future<List<TravelNote>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List<TravelNote>.from(_notes);
  }

  Future<TravelNote> create(TravelNote note) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final newNote = note.copyWith(
      id: _nextId++,
      createdAt: DateTime.now().toIso8601String().substring(0, 10),
    );
    _notes.insert(0, newNote);
    return newNote;
  }

  Future<TravelNote> update(TravelNote note) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index == -1) {
      throw Exception('Catatan perjalanan tidak ditemukan.');
    }
    _notes[index] = note;
    return note;
  }

  Future<void> delete(int id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _notes.removeWhere((n) => n.id == id);
  }
}

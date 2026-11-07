import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/travel_note.dart';
import '../../providers/destination_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/travel_note_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/destination_card.dart';
import '../../widgets/state_views.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _confirmDeleteNote(BuildContext context, TravelNote note) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Hapus Rencana?'),
          ],
        ),
        content: Text('Hapus catatan rencana untuk "${note.destinationName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<TravelNoteProvider>().deleteNote(note.id!);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Catatan rencana berhasil dihapus'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showEditNoteDialog(BuildContext context, TravelNote note) {
    final noteController = TextEditingController(text: note.note);
    final dateController = TextEditingController(text: note.visitDate);
    double noteRating = note.rating;
    bool isVisited = note.isVisited;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Edit Rencana: ${note.destinationName}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: noteController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Catatan Rencana',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Kunjungan (YYYY-MM-DD)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Rating: '),
                    DropdownButton<double>(
                      value: noteRating,
                      items: [5.0, 4.5, 4.0, 3.5, 3.0]
                          .map((r) => DropdownMenuItem(value: r, child: Text('⭐ $r')))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => noteRating = val);
                      },
                    ),
                  ],
                ),
                CheckboxListTile(
                  title: const Text('Sudah Dikunjungi', style: TextStyle(fontSize: 13)),
                  value: isVisited,
                  onChanged: (val) {
                    if (val != null) setDialogState(() => isVisited = val);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: kPrimaryColor),
              onPressed: () {
                final updated = note.copyWith(
                  note: noteController.text.trim(),
                  visitDate: dateController.text.trim(),
                  rating: noteRating,
                  isVisited: isVisited,
                );
                context.read<TravelNoteProvider>().updateNote(updated);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Catatan rencana berhasil diperbarui! ✨'),
                    backgroundColor: kPrimaryColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<DestinationProvider>();
    final favorites = context.watch<FavoritesProvider>();
    final noteProvider = context.watch<TravelNoteProvider>();

    final favItems = p.items.where((d) => d.id != null && favorites.isFavorite(d.id!)).toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Screen Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saved & Wishlist',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: kDarkColor,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kelola destinasi favorit dan rencana perjalananmu',
                    style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade600),
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: kPrimaryColor,
                labelColor: kPrimaryColor,
                unselectedLabelColor: Colors.black54,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: [
                  Tab(
                    icon: const Icon(Icons.favorite_rounded, size: 18),
                    text: 'Favorit (${favItems.length})',
                  ),
                  Tab(
                    icon: const Icon(Icons.note_alt_rounded, size: 18),
                    text: 'Rencana (${noteProvider.count})',
                  ),
                ],
              ),
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Favorit Destinasi
                  if (favItems.isEmpty)
                    const EmptyView(
                      icon: Icons.favorite_border_rounded,
                      message: 'Belum ada destinasi favorit.\nTekan ikon hati ❤️ pada destinasi untuk menyimpannya.',
                    )
                  else
                    CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                          sliver: SliverDestinationGrid(items: favItems),
                        ),
                      ],
                    ),

                  // Tab 2: Rencana Perjalanan / Notes (CRUD)
                  if (noteProvider.items.isEmpty)
                    const EmptyView(
                      icon: Icons.event_note_rounded,
                      message: 'Belum ada rencana perjalanan.\nBuka detail destinasi untuk menambahkan catatan rencana.',
                    )
                  else
                    ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      itemCount: noteProvider.items.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final note = noteProvider.items[index];

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.flight_takeoff_rounded, color: kPrimaryColor, size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          note.destinationName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: kDarkColor,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '📅 Tanggal: ${note.visitDate}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.blueGrey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: note.isVisited
                                          ? Colors.green.shade50
                                          : Colors.orange.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      note.isVisited ? 'Sudah Dikunjungi' : 'Rencana',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: note.isVisited
                                            ? Colors.green.shade700
                                            : Colors.orange.shade800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                note.note,
                                style: const TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF334155)),
                              ),
                              const SizedBox(height: 12),
                              const Divider(height: 1),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Rating: ${note.rating}',
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        tooltip: 'Edit Rencana',
                                        icon: const Icon(Icons.edit_outlined, size: 18, color: kPrimaryColor),
                                        onPressed: () => _showEditNoteDialog(context, note),
                                      ),
                                      IconButton(
                                        tooltip: 'Hapus Rencana',
                                        icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                                        onPressed: () => _confirmDeleteNote(context, note),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

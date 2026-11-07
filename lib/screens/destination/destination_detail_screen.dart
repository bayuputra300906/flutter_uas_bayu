import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/destination.dart';
import '../../models/travel_note.dart';
import '../../providers/destination_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/travel_note_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/destination_card.dart';
import '../../widgets/feature_tag_chip.dart';
import 'edit_destination_screen.dart';

class DestinationDetailScreen extends StatelessWidget {
  const DestinationDetailScreen({super.key, required this.id});

  final int id;

  Future<void> _confirmDelete(BuildContext context, Destination d) async {
    final provider = context.read<DestinationProvider>();
    final favorites = context.read<FavoritesProvider>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Hapus Destinasi?'),
          ],
        ),
        content: Text(
          'Destinasi "${d.name}" akan dihapus secara permanen dari database Supabase.',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus Permanen'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final error = await provider.remove(d.id!);
    if (error != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus: $error'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    favorites.remove(d.id!);
    messenger.showSnackBar(
      SnackBar(
        content: Text('"${d.name}" berhasil dihapus dari database'),
        backgroundColor: kPrimaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
    navigator.pop();
  }

  void _showAddNoteDialog(BuildContext context, Destination d) {
    final noteController = TextEditingController();
    double noteRating = 5.0;
    final date = DateTime.now().toString().substring(0, 10);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Catatan Rencana: ${d.name}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tuliskan rencana kunjungan atau tips perjalanan pribadimu:',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Contoh: Sewa motor jam 8 pagi, bawa kamera...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Rating Ekspektasi: ', style: TextStyle(fontSize: 12)),
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: kPrimaryColor),
              onPressed: () async {
                if (noteController.text.trim().isEmpty) return;
                final travelNote = TravelNote(
                  destinationId: d.id ?? 0,
                  destinationName: d.name,
                  note: noteController.text.trim(),
                  rating: noteRating,
                  visitDate: date,
                );
                await context.read<TravelNoteProvider>().addNote(travelNote);
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Catatan perjalanan berhasil disimpan! 📝'),
                      backgroundColor: kPrimaryColor,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
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
    final d = context.watch<DestinationProvider>().byId(id);
    if (d == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Destinasi')),
        body: const Center(child: Text('Destinasi tidak ditemukan.')),
      );
    }

    final favorites = context.watch<FavoritesProvider>();
    final isFav = favorites.isFavorite(id);
    final notes = context.watch<TravelNoteProvider>().notesForDestination(id);

    final detailsContent = Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Chip & Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: categoryColor(d.category).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: categoryColor(d.category).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(categoryIcon(d.category), size: 16, color: categoryColor(d.category)),
                    const SizedBox(width: 6),
                    Text(
                      d.category,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: categoryColor(d.category),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBBF24).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, size: 18, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 4),
                    Text(
                      d.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFB45309),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '(120+ reviews)',
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Title
          Text(
            d.name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: kDarkColor,
              letterSpacing: -0.6,
            ),
          ),

          const SizedBox(height: 8),

          // Location
          Row(
            children: [
              const Icon(Icons.location_on_rounded, size: 18, color: kPrimaryColor),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  d.location,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blueGrey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Feature Badges (Matching photo!)
          const Text(
            'Fasilitas & Keunggulan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: kDarkColor,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: d.tags.map((tag) => FeatureTagChip(tag: tag)).toList(),
          ),

          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 20),

          // About Destination / Description
          const Text(
            'About Destination',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kDarkColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            d.description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF334155),
            ),
          ),

          const SizedBox(height: 24),

          // Personal Notes / Itinerary section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Catatan Perjalanan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kDarkColor,
                ),
              ),
              TextButton.icon(
                onPressed: () => _showAddNoteDialog(context, d),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Tambah Catatan'),
                style: TextButton.styleFrom(foregroundColor: kPrimaryColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (notes.isEmpty)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.notes_rounded, color: Colors.black38),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Belum ada catatan pribadi untuk tempat ini.',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            )
          else
            ...notes.map(
              (n) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '📅 Rencana: ${n.visitDate}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kPrimaryColor),
                        ),
                        Text('⭐ ${n.rating}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(n.note, style: const TextStyle(fontSize: 13, color: kDarkColor)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );

    // Fixed Bottom Action Bar matching photo!
    final bottomBar = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Harga Tiket Masuk',
                  style: TextStyle(fontSize: 11, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  formatRupiah(d.price),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  final added = favorites.toggle(id);
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        added
                            ? '${d.name} ditambahkan ke Favorit! ❤️'
                            : '${d.name} dihapus dari Favorit',
                      ),
                    ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFav ? const Color(0xFFEF4444) : const Color(0xFF84CC16),
                  foregroundColor: isFav ? Colors.white : const Color(0xFF0F172A),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: Icon(
                  isFav ? Icons.favorite_rounded : Icons.bookmark_add_rounded,
                  size: 20,
                ),
                label: Text(
                  isFav ? 'Tersimpan di Favorit' : 'Simpan ke Wishlist',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: kBackgroundColor,
      bottomNavigationBar: bottomBar,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 750;

          if (isWide) {
            // Wide Screen: Side-by-side Layout
            return Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      DestinationImage(destination: d, iconSize: 96),
                      // Back Button
                      Positioned(
                        top: 40,
                        left: 20,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_rounded, color: kDarkColor),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      title: Text(d.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      actions: [
                        IconButton(
                          tooltip: 'Edit Destinasi',
                          icon: const Icon(Icons.edit_rounded),
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => EditDestinationScreen(destination: d),
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Hapus Destinasi',
                          icon: const Icon(Icons.delete_rounded, color: Colors.red),
                          onPressed: () => _confirmDelete(context, d),
                        ),
                      ],
                    ),
                    body: SingleChildScrollView(child: detailsContent),
                  ),
                ),
              ],
            );
          }

          // Compact / Mobile Layout: Full Bleed Header with Overlay Buttons
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                backgroundColor: kPrimaryColor,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: kDarkColor, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    child: IconButton(
                      tooltip: 'Edit',
                      icon: const Icon(Icons.edit_rounded, color: kDarkColor, size: 18),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EditDestinationScreen(destination: d),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    child: IconButton(
                      tooltip: 'Hapus',
                      icon: const Icon(Icons.delete_rounded, color: Colors.red, size: 18),
                      onPressed: () => _confirmDelete(context, d),
                    ),
                  ),
                  const SizedBox(width: 14),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      DestinationImage(destination: d, iconSize: 80),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.4),
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.5),
                              ],
                              stops: const [0.0, 0.4, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: detailsContent,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

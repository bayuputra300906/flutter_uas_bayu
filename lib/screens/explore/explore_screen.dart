import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/destination_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/destination_card.dart';
import '../../widgets/state_views.dart';
import '../destination/add_destination_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<DestinationProvider>();

    if (_controller.text != p.query) {
      _controller.text = p.query;
    }

    final categories = ['Semua', ...kCategories];
    final results = p.filtered;

    Widget body;
    switch (p.status) {
      case LoadStatus.initial:
      case LoadStatus.loading:
        body = const LoadingView(message: 'Mencari destinasi...');
        break;
      case LoadStatus.error:
        body = ErrorView(
          message: p.error ?? 'Gagal memuat katalog destinasi',
          onRetry: p.load,
        );
        break;
      case LoadStatus.success:
        if (results.isEmpty) {
          body = EmptyView(
            message: p.items.isEmpty
                ? 'Belum ada destinasi.\nTekan tombol + untuk menambahkan.'
                : 'Tidak ada destinasi yang cocok dengan pencarian.',
            actionLabel: p.items.isNotEmpty ? 'Reset Pencarian' : null,
            onAction: p.items.isNotEmpty ? p.resetFilters : null,
          );
        } else {
          body = RefreshIndicator(
            onRefresh: p.load,
            color: kPrimaryColor,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 90),
                  sliver: SliverDestinationGrid(items: results),
                ),
              ],
            ),
          );
        }
        break;
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_destination_btn',
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddDestinationScreen()),
        ),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Wisata', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top App Bar Area
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explore Bali',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: kDarkColor,
                              letterSpacing: -0.6,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Temukan semua surga tersembunyi',
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                      // Sort Menu
                      PopupMenuButton<String>(
                        tooltip: 'Urutkan',
                        initialValue: p.sortBy,
                        onSelected: p.setSortBy,
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: const Icon(Icons.sort_rounded, size: 20, color: kDarkColor),
                        ),
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'Popular', child: Text('Terpopuler')),
                          const PopupMenuItem(value: 'Rating', child: Text('Rating Tertinggi')),
                          const PopupMenuItem(value: 'Harga Terendah', child: Text('Harga Termurah')),
                          const PopupMenuItem(value: 'Harga Tertinggi', child: Text('Harga Termahal')),
                          const PopupMenuItem(value: 'Nama', child: Text('Nama (A-Z)')),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: SearchBar(
                      controller: _controller,
                      hintText: 'Cari nama, lokasi, atau deskripsi...',
                      leading: const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(Icons.search_rounded, color: kPrimaryColor),
                      ),
                      elevation: const WidgetStatePropertyAll(0),
                      backgroundColor: const WidgetStatePropertyAll(Colors.white),
                      trailing: [
                        if (p.query.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 20),
                            onPressed: () {
                              _controller.clear();
                              p.setQuery('');
                            },
                          ),
                      ],
                      onChanged: p.setQuery,
                    ),
                  ),
                ],
              ),
            ),

            // Category Horizontal Choice Chips
            SizedBox(
              height: 42,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final cat = categories[i];
                  final isSelected = p.category == cat;

                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: kPrimaryColor,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : kDarkColor,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: isSelected ? kPrimaryColor : Colors.black12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onSelected: (selected) {
                      if (selected) p.setCategory(cat);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // Main Catalog Body
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

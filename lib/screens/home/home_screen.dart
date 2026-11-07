import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/destination_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/destination_card.dart';
import '../../widgets/nearby_destination_card.dart';
import '../../widgets/state_views.dart';
import '../../widgets/weather_banner.dart';
import '../explore/explore_screen.dart';
import '../favorites/favorites_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  void _go(int index) {
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 750;

    final pages = [
      HomeTab(onOpenExplore: () => _go(1)),
      const ExploreScreen(),
      const FavoritesScreen(),
      const ProfileScreen(),
    ];

    const destinations = [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home_rounded),
        label: 'Home',
      ),
      NavigationDestination(
        icon: Icon(Icons.explore_outlined),
        selectedIcon: Icon(Icons.explore_rounded),
        label: 'Explore',
      ),
      NavigationDestination(
        icon: Icon(Icons.favorite_border_rounded),
        selectedIcon: Icon(Icons.favorite_rounded),
        label: 'Favorites',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline_rounded),
        selectedIcon: Icon(Icons.person_rounded),
        label: 'Profile',
      ),
    ];

    final content = IndexedStack(
      index: _index,
      children: pages,
    );

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: _go,
              labelType: NavigationRailLabelType.all,
              backgroundColor: Colors.white,
              indicatorColor: kPrimaryColor.withValues(alpha: 0.15),
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: kPrimaryColor,
                  child: const Icon(Icons.travel_explore_rounded, color: Colors.white, size: 22),
                ),
              ),
              destinations: destinations
                  .map(
                    (d) => NavigationRailDestination(
                      icon: d.icon,
                      selectedIcon: d.selectedIcon,
                      label: Text(d.label),
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: content),
          ],
        ),
      );
    }

    return Scaffold(
      body: content,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _go,
        backgroundColor: Colors.white,
        elevation: 8,
        shadowColor: Colors.black12,
        indicatorColor: kPrimaryColor.withValues(alpha: 0.15),
        destinations: destinations,
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({
    super.key,
    required this.onOpenExplore,
  });

  final VoidCallback onOpenExplore;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<DestinationProvider>();
    final popular = p.popular;
    final nearby = p.nearby.isNotEmpty ? p.nearby : popular;

    final categories = [
      _CategoryItem('Semua', Icons.grid_view_rounded, const Color(0xFF00A896)),
      _CategoryItem('Pantai', Icons.beach_access_rounded, const Color(0xFF06B6D4)),
      _CategoryItem('Wisata Alam', Icons.park_rounded, const Color(0xFF10B981)),
      _CategoryItem('Budaya', Icons.temple_buddhist_rounded, const Color(0xFFF59E0B)),
      _CategoryItem('Pegunungan', Icons.landscape_rounded, const Color(0xFF6366F1)),
      _CategoryItem('Kuliner', Icons.restaurant_rounded, const Color(0xFFEC4899)),
    ];

    final Widget destinationContent = switch (p.status) {
      LoadStatus.initial || LoadStatus.loading =>
        const SliverFillRemaining(
          hasScrollBody: false,
          child: LoadingView(message: 'Memuat destinasi terbaik Bali...'),
        ),
      LoadStatus.error =>
        SliverFillRemaining(
          hasScrollBody: false,
          child: ErrorView(
            message: p.error ?? 'Gagal memuat destinasi wisata.',
            onRetry: p.load,
          ),
        ),
      LoadStatus.success =>
        popular.isEmpty
            ? const SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyView(
                  message: 'Belum ada destinasi wisata.',
                ),
              )
            : SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                sliver: SliverDestinationGrid(items: popular),
              ),
    };

    return SafeArea(
      child: Container(
        color: kBackgroundColor,
        child: RefreshIndicator(
          onRefresh: p.load,
          color: kPrimaryColor,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // 1. TOP HEADER: Location, Greeting, Profile Avatar (as in photo)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: kPrimaryColor.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 22,
                          backgroundColor: Color(0xFFDDF4F0),
                          child: Text(
                            'GB',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Greeting
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'GOOD MORNING',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text('👋', style: TextStyle(fontSize: 11)),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Halo, Bayu!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: kDarkColor,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Location pill on right (as in photo)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on_rounded, size: 14, color: kPrimaryColor),
                            SizedBox(width: 4),
                            Text(
                              'Bali, ID',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: kDarkColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. LIVE BALI WEATHER WIDGET (GET REST API)
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: WeatherBanner(),
                ),
              ),

              // 3. SEARCH BAR (as in photo)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SearchBar(
                      hintText: 'Search destination...',
                      leading: const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(Icons.search_rounded, color: kPrimaryColor, size: 22),
                      ),
                      trailing: [
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.tune_rounded, color: Colors.white, size: 18),
                        ),
                      ],
                      elevation: const WidgetStatePropertyAll(0),
                      backgroundColor: const WidgetStatePropertyAll(Colors.white),
                      onSubmitted: (value) {
                        p.setCategory('Semua');
                        p.setQuery(value);
                        onOpenExplore();
                      },
                    ),
                  ),
                ),
              ),

              // 4. "Where do you wanna go?" / CATEGORIES SECTION
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Where do you wanna go?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: kDarkColor,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 90,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 14),
                          itemBuilder: (context, index) {
                            final item = categories[index];
                            final isSelected = p.category == item.name;

                            return InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () {
                                p.setCategory(item.name);
                                onOpenExplore();
                              },
                              child: SizedBox(
                                width: 68,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 58,
                                      width: 58,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? item.color
                                            : item.color.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                          color: item.color.withValues(alpha: 0.25),
                                        ),
                                      ),
                                      child: Icon(
                                        item.icon,
                                        color: isSelected ? Colors.white : item.color,
                                        size: 26,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item.name,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                        color: kDarkColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 5. "Nearby Destination" HORIZONTAL SCROLL CAROUSEL (as in photo)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Nearby Destination',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: kDarkColor,
                              letterSpacing: -0.4,
                            ),
                          ),
                          TextButton(
                            onPressed: onOpenExplore,
                            child: const Text(
                              'See All',
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 245,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: nearby.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 14),
                          itemBuilder: (context, index) {
                            return NearbyDestinationCard(destination: nearby[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 6. "Popular Places" / "Top Picks" HEADER
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Popular Places',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: kDarkColor,
                          letterSpacing: -0.4,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          p.resetFilters();
                          onOpenExplore();
                        },
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 7. POPULAR PLACES GRID
              destinationContent,

              // Bottom spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryItem {
  final String name;
  final IconData icon;
  final Color color;

  const _CategoryItem(this.name, this.icon, this.color);
}

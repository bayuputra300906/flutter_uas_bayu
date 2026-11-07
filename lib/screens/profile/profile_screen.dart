import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/destination_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/travel_note_provider.dart';
import '../../utils/constants.dart';
import '../onboarding/onboarding_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final total = context.watch<DestinationProvider>().items.length;
    final favCount = context.watch<FavoritesProvider>().count;
    final noteCount = context.watch<TravelNoteProvider>().count;

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Profile Header Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F766E), Color(0xFF00A896)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryColor.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFFDDF4F0),
                        child: Text(
                          'GB',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Gede Bayu Putra Darmawan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'NIM: 2415051105 · Kelas: PTI 5A',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Statistics Cards
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Destinasi',
                      value: '$total',
                      icon: Icons.place_rounded,
                      color: const Color(0xFF00A896),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      label: 'Favorit',
                      value: '$favCount',
                      icon: Icons.favorite_rounded,
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      label: 'Rencana',
                      value: '$noteCount',
                      icon: Icons.event_note_rounded,
                      color: const Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // UTS Information Section
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
                ),
                child: Column(
                  children: [
                    const ListTile(
                      leading: Icon(Icons.school_rounded, color: kPrimaryColor),
                      title: Text('Mata Kuliah', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text('Pemrograman Mobile (Worksheet 1–7)'),
                    ),
                    const Divider(height: 1),
                    const ListTile(
                      leading: Icon(Icons.person_outline_rounded, color: kPrimaryColor),
                      title: Text('Dosen Pengampu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text('Dr. Ir. I Ketut Resika Arthana, S.T., M.Kom'),
                    ),
                    const Divider(height: 1),
                    const ListTile(
                      leading: Icon(Icons.support_agent_rounded, color: kPrimaryColor),
                      title: Text('Teaching Assistant', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text('Made Yuda Sadewa, S.Pd.'),
                    ),
                    const Divider(height: 1),
                    const ListTile(
                      leading: Icon(Icons.layers_rounded, color: kPrimaryColor),
                      title: Text('Arsitektur Aplikasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text('UI → Provider → Repository → Service → Supabase / Open-Meteo REST API'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Action Options Card
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF84CC16)),
                      title: const Text('Buka Onboarding Screen', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: const Text('Tampilkan layar selamat datang'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.info_outline_rounded, color: kPrimaryColor),
                      title: const Text('Tentang TravelBuddy', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => showAboutDialog(
                        context: context,
                        applicationName: 'TravelBuddy',
                        applicationVersion: 'v1.0.0 (UTS Edition)',
                        applicationIcon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.travel_explore_rounded, color: Colors.white, size: 28),
                        ),
                        children: const [
                          SizedBox(height: 10),
                          Text(
                            'TravelBuddy adalah aplikasi mobile pencarian dan informasi destinasi wisata di Bali.\n\n'
                            'Dibuat oleh Gede Bayu Putra Darmawan (NIM: 2415051105) untuk Ujian Tengah Semester mata kuliah Pemrograman Mobile PTI 5A.\n\n'
                            'Fitur Utama:\n'
                            '• Live Bali Weather via Open-Meteo REST API\n'
                            '• Supabase PostgreSQL Database Integration\n'
                            '• Full CRUD Destinasi & Catatan Rencana Perjalanan\n'
                            '• Responsive Layout (Compact & Wide)\n'
                            '• Provider State Management\n'
                            '• Form Validation & User Feedback (SnackBar, Dialog)',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: kDarkColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

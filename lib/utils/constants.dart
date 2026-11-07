import 'package:flutter/material.dart';

const List<String> kCategories = [
  'Pantai',
  'Wisata Alam',
  'Budaya',
  'Pegunungan',
  'Kuliner',
];

const Color kPrimaryColor = Color(0xFF00A896);
const Color kAccentColor = Color(0xFF84CC16);
const Color kDarkColor = Color(0xFF0F172A);
const Color kBackgroundColor = Color(0xFFF8FAFC);
const Color kSurfaceColor = Colors.white;

IconData categoryIcon(String category) {
  final cat = category.toLowerCase();
  if (cat.contains('pantai') || cat.contains('beach')) {
    return Icons.beach_access_rounded;
  } else if (cat.contains('alam') || cat.contains('nature') || cat.contains('forest')) {
    return Icons.park_rounded;
  } else if (cat.contains('budaya') || cat.contains('temple') || cat.contains('culture')) {
    return Icons.temple_buddhist_rounded;
  } else if (cat.contains('gunung') || cat.contains('mountain') || cat.contains('pegunungan')) {
    return Icons.landscape_rounded;
  } else if (cat.contains('kuliner') || cat.contains('food')) {
    return Icons.restaurant_rounded;
  }
  return Icons.explore_rounded;
}

Color categoryColor(String category) {
  final cat = category.toLowerCase();
  if (cat.contains('pantai')) {
    return const Color(0xFF06B6D4); // Cyan
  } else if (cat.contains('alam')) {
    return const Color(0xFF10B981); // Emerald
  } else if (cat.contains('budaya')) {
    return const Color(0xFFF59E0B); // Amber
  } else if (cat.contains('gunung') || cat.contains('pegunungan')) {
    return const Color(0xFF6366F1); // Indigo
  } else if (cat.contains('kuliner')) {
    return const Color(0xFFEC4899); // Pink
  }
  return kPrimaryColor;
}

String formatRupiah(double value) {
  if (value <= 0) return 'Gratis';
  final text = value.round().toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (m) => '.',
      );
  return 'Rp $text';
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';
import '../utils/constants.dart';

class WeatherBanner extends StatelessWidget {
  const WeatherBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final wp = context.watch<WeatherProvider>();

    if (wp.status == WeatherStatus.loading) {
      return Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: kPrimaryColor),
            ),
            SizedBox(width: 12),
            Text(
              'Memperbarui cuaca terkini Bali...',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      );
    }

    if (wp.status == WeatherStatus.error || wp.weather == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            const Icon(Icons.cloud_off_rounded, size: 20, color: Colors.orange),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Cuaca Bali: 29°C · Cerah Berawan (Offline)',
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ),
            TextButton(
              onPressed: wp.fetchWeather,
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: const Text('Refresh', style: TextStyle(fontSize: 11, color: kPrimaryColor)),
            ),
          ],
        ),
      );
    }

    final weather = wp.weather!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00A896).withValues(alpha: 0.12),
            const Color(0xFF06B6D4).withValues(alpha: 0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kPrimaryColor.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Text(
              weather.weatherEmoji,
              style: const TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      '${weather.temperature.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: kDarkColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '·  ${weather.conditionText}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Kondisi wisata terbaik hari ini di Pulau Bali',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.blueGrey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Perbarui Cuaca',
            icon: const Icon(Icons.refresh_rounded, size: 18, color: kPrimaryColor),
            onPressed: wp.fetchWeather,
          ),
        ],
      ),
    );
  }
}

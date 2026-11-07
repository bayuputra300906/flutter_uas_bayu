import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_uas_bayu/models/destination.dart';
import 'package:flutter_uas_bayu/models/travel_note.dart';
import 'package:flutter_uas_bayu/models/weather_info.dart';
import 'package:flutter_uas_bayu/providers/favorites_provider.dart';

void main() {
  group('Dart Models Tests', () {
    test('Destination model serialization and deserialization', () {
      final json = {
        'id': 1,
        'name': 'Kelingking Beach',
        'location': 'Nusa Penida, Bali',
        'category': 'Pantai',
        'description': 'Pantai dengan tebing ikonik.',
        'image_url': 'https://example.com/kelingking.jpg',
        'price': 25000,
        'rating': 4.8,
        'tags': ['Scenic View', 'Island Friendly'],
      };

      final destination = Destination.fromJson(json);
      expect(destination.id, 1);
      expect(destination.name, 'Kelingking Beach');
      expect(destination.price, 25000.0);
      expect(destination.rating, 4.8);
      expect(destination.tags.length, 2);

      final outJson = destination.toJson();
      expect(outJson['name'], 'Kelingking Beach');
      expect(outJson['image_url'], 'https://example.com/kelingking.jpg');
    });

    test('TravelNote model serialization', () {
      final note = const TravelNote(
        id: 10,
        destinationId: 1,
        destinationName: 'Kelingking Beach',
        note: 'Sewa boat jam 7 pagi',
        rating: 5.0,
        visitDate: '2026-12-15',
        isVisited: true,
      );

      final json = note.toJson();
      expect(json['destination_name'], 'Kelingking Beach');
      expect(json['is_visited'], true);

      final fromJson = TravelNote.fromJson(json);
      expect(fromJson.destinationId, 1);
      expect(fromJson.note, 'Sewa boat jam 7 pagi');
    });

    test('WeatherInfo condition mapping', () {
      final weather = const WeatherInfo(
        temperature: 29.5,
        windspeed: 12.0,
        weatherCode: 0,
        isDay: true,
        locationName: 'Bali, Indonesia',
      );

      expect(weather.conditionText, 'Cerah Berawan');
      expect(weather.weatherEmoji, '☀️');
    });
  });

  group('FavoritesProvider State Management Tests', () {
    test('Toggle favorite adds and removes id properly', () {
      final provider = FavoritesProvider();
      provider.clear();
      expect(provider.count, 0);

      final added = provider.toggle(99);
      expect(added, true);
      expect(provider.isFavorite(99), true);
      expect(provider.count, 1);

      final removed = provider.toggle(99);
      expect(removed, false);
      expect(provider.isFavorite(99), false);
      expect(provider.count, 0);
    });
  });
}

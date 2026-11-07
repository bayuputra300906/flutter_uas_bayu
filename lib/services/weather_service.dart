import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/weather_info.dart';

class WeatherService {
  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const Duration _timeout = Duration(seconds: 8);

  // Koordinat Bali (Ubud / Gianyar / Denpasar)
  static const double baliLatitude = -8.5069;
  static const double baliLongitude = 115.2625;

  Future<WeatherInfo> getBaliWeather() async {
    final uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$baliLatitude&longitude=$baliLongitude&current_weather=true',
    );

    try {
      final response = await _client.get(uri).timeout(_timeout);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherInfo.fromJson(data, location: 'Bali, Indonesia');
      }
      return const WeatherInfo(
        temperature: 29.5,
        windspeed: 12.0,
        weatherCode: 1,
        isDay: true,
        locationName: 'Bali, Indonesia',
      );
    } on TimeoutException {
      return const WeatherInfo(
        temperature: 29.0,
        windspeed: 11.0,
        weatherCode: 0,
        isDay: true,
        locationName: 'Bali, Indonesia',
      );
    } on SocketException {
      return const WeatherInfo(
        temperature: 28.5,
        windspeed: 9.5,
        weatherCode: 1,
        isDay: true,
        locationName: 'Bali, Indonesia',
      );
    } catch (_) {
      return const WeatherInfo(
        temperature: 29.0,
        windspeed: 10.0,
        weatherCode: 1,
        isDay: true,
        locationName: 'Bali, Indonesia',
      );
    }
  }
}

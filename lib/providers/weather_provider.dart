import 'package:flutter/foundation.dart';

import '../models/weather_info.dart';
import '../repositories/weather_repository.dart';

enum WeatherStatus { initial, loading, success, error }

class WeatherProvider extends ChangeNotifier {
  WeatherProvider(this._repository);

  final WeatherRepository _repository;

  WeatherStatus _status = WeatherStatus.initial;
  WeatherInfo? _weather;
  String? _error;

  WeatherStatus get status => _status;
  WeatherInfo? get weather => _weather;
  String? get error => _error;

  Future<void> fetchWeather() async {
    _status = WeatherStatus.loading;
    _error = null;
    notifyListeners();

    try {
      _weather = await _repository.getWeather();
      _status = WeatherStatus.success;
    } catch (e) {
      _error = e.toString();
      _status = WeatherStatus.error;
    }
    notifyListeners();
  }
}

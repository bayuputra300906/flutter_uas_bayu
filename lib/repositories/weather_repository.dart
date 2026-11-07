import '../models/weather_info.dart';
import '../services/weather_service.dart';

class WeatherRepository {
  WeatherRepository(this._service);

  final WeatherService _service;

  Future<WeatherInfo> getWeather() => _service.getBaliWeather();
}

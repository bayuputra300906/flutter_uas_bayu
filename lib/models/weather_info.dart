class WeatherInfo {
  const WeatherInfo({
    required this.temperature,
    required this.windspeed,
    required this.weatherCode,
    required this.isDay,
    required this.locationName,
  });

  final double temperature;
  final double windspeed;
  final int weatherCode;
  final bool isDay;
  final String locationName;

  factory WeatherInfo.fromJson(Map<String, dynamic> json, {String location = 'Bali, Indonesia'}) {
    final current = json['current_weather'] as Map<String, dynamic>? ?? json;
    return WeatherInfo(
      temperature: (current['temperature'] as num?)?.toDouble() ?? 29.0,
      windspeed: (current['windspeed'] as num?)?.toDouble() ?? 10.0,
      weatherCode: (current['weathercode'] as num?)?.toInt() ?? 0,
      isDay: (current['is_day'] as num?)?.toInt() == 1,
      locationName: location,
    );
  }

  String get conditionText {
    switch (weatherCode) {
      case 0:
        return 'Cerah Berawan';
      case 1:
      case 2:
        return 'Sebagian Berawan';
      case 3:
        return 'Berawan Tebal';
      case 45:
      case 48:
        return 'Berkabut';
      case 51:
      case 53:
      case 55:
        return 'Gerimis Sejuk';
      case 61:
      case 63:
      case 65:
        return 'Hujan Tropis';
      case 80:
      case 81:
      case 82:
        return 'Hujan Lebat';
      case 95:
      case 96:
      case 99:
        return 'Badai Petir';
      default:
        return 'Cerah Menyenangkan';
    }
  }

  String get weatherEmoji {
    switch (weatherCode) {
      case 0:
        return '☀️';
      case 1:
      case 2:
        return '🌤️';
      case 3:
        return '☁️';
      case 45:
      case 48:
        return '🌫️';
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
        return '🌧️';
      case 80:
      case 81:
      case 82:
        return '⛈️';
      default:
        return '☀️';
    }
  }
}

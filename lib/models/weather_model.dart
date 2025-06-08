class WeatherModel {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final double windSpeed;
  final int humidity;
  final int pressure;
  final double feelsLike;
  final double latitude;
  final double longitude;
  final DateTime sunrise;
  final DateTime sunset;
  final double visibility;
  final double uvi;
  final double precipitationProbability;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.windSpeed,
    required this.humidity,
    required this.pressure,
    required this.feelsLike,
    required this.latitude,
    required this.longitude,
    required this.sunrise,
    required this.sunset,
    required this.visibility,
    required this.uvi,
    required this.precipitationProbability,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      windSpeed: json['wind']['speed'].toDouble(),
      humidity: json['main']['humidity'],
      pressure: json['main']['pressure'],
      feelsLike: json['main']['feels_like'].toDouble(),
      latitude: json['coord']['lat'].toDouble(),
      longitude: json['coord']['lon'].toDouble(),
      sunrise:
          DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000),
      visibility: (json['visibility'] as num).toDouble() /
          1000, // Convert to kilometers
      uvi: json['uvi']?.toDouble() ?? 0.0,
      precipitationProbability: (json['pop'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

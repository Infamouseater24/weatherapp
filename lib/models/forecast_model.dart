class ForecastModel {
  final DateTime date;
  final double temperature;
  final String description;
  final String icon;
  final double windSpeed;
  final int humidity;
  final int pressure;

  ForecastModel({
    required this.date,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.windSpeed,
    required this.humidity,
    required this.pressure,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      windSpeed: json['wind']['speed'].toDouble(),
      humidity: json['main']['humidity'],
      pressure: json['main']['pressure'],
    );
  }
}

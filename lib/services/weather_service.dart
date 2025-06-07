import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/models/forecast_model.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  final String apiKey;

  WeatherService({required this.apiKey});

  Future<WeatherModel> getWeatherByCity(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/weather?q=$city&appid=$apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }

  Future<WeatherModel> getWeatherByLocation(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
        ),
      );

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }

  Future<List<ForecastModel>> getForecastByCity(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/forecast?q=$city&appid=$apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data['list'];
        return list.map((item) => ForecastModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load forecast data');
      }
    } catch (e) {
      throw Exception('Error fetching forecast data: $e');
    }
  }

  Future<List<ForecastModel>> getForecastByLocation(
    double lat,
    double lon,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data['list'];
        return list.map((item) => ForecastModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load forecast data');
      }
    } catch (e) {
      throw Exception('Error fetching forecast data: $e');
    }
  }
}

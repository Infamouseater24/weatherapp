import 'package:flutter/material.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/constants/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 4,
      color: isDark ? null : Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: isDark
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade50, Colors.blue.shade100],
                ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                weather.cityName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: isDark ? null : Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 8),
              CachedNetworkImage(
                imageUrl:
                    '${Constants.weatherIconBaseUrl}${weather.icon}@2x.png',
                height: 100,
                width: 100,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(height: 8),
              Text(
                '${weather.temperature.toStringAsFixed(1)}°C',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: isDark ? null : Colors.blue.shade900,
                ),
              ),
              Text(
                weather.description.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark ? null : Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWeatherInfo(
                    context,
                    Icons.water_drop,
                    '${weather.humidity}%',
                    'Humidity',
                    isDark,
                  ),
                  _buildWeatherInfo(
                    context,
                    Icons.air,
                    '${weather.windSpeed} m/s',
                    'Wind',
                    isDark,
                  ),
                  _buildWeatherInfo(
                    context,
                    Icons.compress,
                    '${weather.pressure} hPa',
                    'Pressure',
                    isDark,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    bool isDark,
  ) {
    final iconColor = isDark ? null : Colors.blue.shade700;
    final textColor = isDark ? null : Colors.blue.shade900;

    return Column(
      children: [
        Icon(icon, size: 24, color: iconColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: textColor),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: textColor),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:weatherapp/models/forecast_model.dart';
import 'package:weatherapp/constants/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class ForecastCard extends StatelessWidget {
  final ForecastModel forecast;

  const ForecastCard({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      color: isDark ? null : Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: isDark
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade50, Colors.blue.shade100],
                ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE, MMM d').format(forecast.date),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: isDark ? null : Colors.blue.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      forecast.description.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark ? null : Colors.blue.shade700,
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: CachedNetworkImage(
                  imageUrl:
                      '${Constants.weatherIconBaseUrl}${forecast.icon}@2x.png',
                  height: 50,
                  width: 50,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${forecast.temperature.toStringAsFixed(1)}°C',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: isDark ? null : Colors.blue.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Humidity: ${forecast.humidity}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDark ? null : Colors.blue.shade700,
                          ),
                    ),
                    Text(
                      'Wind: ${forecast.windSpeed} m/s',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDark ? null : Colors.blue.shade700,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

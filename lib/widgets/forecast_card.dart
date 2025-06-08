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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('E, MMM d').format(forecast.date),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isDark ? null : Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 4),
              CachedNetworkImage(
                imageUrl:
                    '${Constants.weatherIconBaseUrl}${forecast.icon}@2x.png',
                height: 50,
                width: 50,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(height: 4),
              Text(
                '${forecast.temperature.toStringAsFixed(1)}°C',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isDark ? null : Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                forecast.description.toUpperCase(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDark ? null : Colors.blue.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

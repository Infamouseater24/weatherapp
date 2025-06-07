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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormat('E, MMM d').format(forecast.date),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            CachedNetworkImage(
              imageUrl:
                  '${Constants.weatherIconBaseUrl}${forecast.icon}@2x.png',
              height: 50,
              width: 50,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(height: 4),
            Text(
              '${forecast.temperature.toStringAsFixed(1)}°C',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              forecast.description.toUpperCase(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

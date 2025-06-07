import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/constants/constants.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/models/forecast_model.dart';
import 'package:weatherapp/services/weather_service.dart';
import 'package:weatherapp/widgets/weather_card.dart';
import 'package:weatherapp/widgets/forecast_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weatherapp/utils/theme_provider.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _searchController = TextEditingController();
  final WeatherService _weatherService = WeatherService(
    apiKey: Constants.apiKey,
  );
  WeatherModel? _weather;
  List<ForecastModel>? _forecast;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initLocationWeather();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initLocationWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _error = 'Location permissions are denied';
            _isLoading = false;
          });
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _error =
              'Location permissions are permanently denied, we cannot request permissions.';
          _isLoading = false;
        });
        return;
      }
      final position = await Geolocator.getCurrentPosition();
      final weather = await _weatherService.getWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      final forecast = await _weatherService.getForecastByLocation(
        position.latitude,
        position.longitude,
      );
      setState(() {
        _weather = weather;
        _forecast = forecast;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = Constants.locationErrorMessage;
        _isLoading = false;
      });
    }
  }

  Future<void> _getWeatherByCity(String city) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final weather = await _weatherService.getWeatherByCity(city);
      final forecast = await _weatherService.getForecastByCity(city);
      setState(() {
        _weather = weather;
        _forecast = forecast;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = Constants.errorMessage;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appName),
        centerTitle: true,
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              final isDark = themeProvider.themeMode == ThemeMode.dark;
              return Row(
                children: [
                  Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                  Switch(
                    value: isDark,
                    onChanged: (value) {
                      themeProvider.toggleTheme(value);
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: Constants.searchHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _getWeatherByCity(value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_searchController.text.isNotEmpty) {
                      _getWeatherByCity(_searchController.text);
                    }
                  },
                  child: const Text(Constants.searchButton),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _initLocationWeather,
              icon: const Icon(Icons.my_location),
              label: const Text(Constants.locationButton),
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(
                child: SpinKitDoubleBounce(color: Colors.blue, size: 50.0),
              )
            else if (_error != null)
              Center(
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              )
            else if (_weather != null)
              Expanded(
                child: Column(
                  children: [
                    WeatherCard(weather: _weather!),
                    const SizedBox(height: 16),
                    if (_forecast != null)
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _forecast!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ForecastCard(forecast: _forecast![index]),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

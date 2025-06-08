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
import 'package:weatherapp/models/favorite_city.dart';
import 'package:weatherapp/services/favorite_cities_service.dart';

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
  final FavoriteCitiesService _favoriteCitiesService = FavoriteCitiesService();
  WeatherModel? _weather;
  List<ForecastModel>? _forecast;
  List<FavoriteCity> _favoriteCities = [];
  bool _isLoading = false;
  String? _error;
  FavoriteCity? _selectedCity;

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
      final weather = await _weatherService.getCurrentLocationWeather();
      final forecast = await _weatherService.getForecastByLocation(
        weather.latitude,
        weather.longitude,
      );

      setState(() {
        _weather = weather;
        _forecast = forecast;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString().replaceAll('Exception: ', '');
        // If the error is about Google Play Services, show a more user-friendly message
        if (_error!.contains('Google Play Services')) {
          _error =
              'Location services are not available. Please search for a city instead.';
        }
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

  Future<void> _getWeatherForFavorite(FavoriteCity city) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _selectedCity = city;
    });
    try {
      final weather = await _weatherService.getWeatherByCity(city.name);
      final forecast = await _weatherService.getForecastByCity(city.name);
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

  Future<void> _removeFavoriteCity(FavoriteCity city) async {
    await _favoriteCitiesService.removeFavoriteCity(city);
    _loadFavoriteCities();
  }

  Future<void> _loadFavoriteCities() async {
    final cities = await _favoriteCitiesService.getFavoriteCities();
    setState(() {
      _favoriteCities = cities;
    });
  }

  Future<void> _getCurrentLocationWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final weather = await _weatherService.getCurrentLocationWeather();
      final forecast = await _weatherService.getForecastByCity(
        weather.cityName,
      );
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

  Future<void> _addCurrentCityToFavorites() async {
    if (_weather == null) return;
    final city = FavoriteCity(
      name: _weather!.cityName,
      lat: 0, // You can enhance this by storing lat/lon if available
      lon: 0,
    );
    await _favoriteCitiesService.addFavoriteCity(city);
    _loadFavoriteCities();
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
        child: SingleChildScrollView(
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
              if (_favoriteCities.isNotEmpty)
                SizedBox(
                  height: 60,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _favoriteCities.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final city = _favoriteCities[index];
                      final isSelected =
                          _selectedCity?.name == city.name ||
                          (_selectedCity == null && index == 0);
                      return InkWell(
                        onTap: () => _getWeatherForFavorite(city),
                        child: Chip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                size: 18,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4),
                              Text(city.name),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () => _removeFavoriteCity(city),
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: isSelected
                              ? Colors.blue[200]
                              : Colors.blue[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: isSelected ? 4 : 1,
                          shadowColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (_isLoading)
                const Center(
                  child: SpinKitDoubleBounce(color: Colors.blue, size: 50.0),
                )
              else if (_error != null)
                Center(
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              else if (_weather != null)
                Column(
                  children: [
                    WeatherCard(weather: _weather!),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _addCurrentCityToFavorites,
                      icon: const Icon(Icons.star),
                      label: const Text('Add to Favorites'),
                    ),
                    const SizedBox(height: 16),
                    if (_forecast != null)
                      SizedBox(
                        height: 150,
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
            ],
          ),
        ),
      ),
    );
  }
}

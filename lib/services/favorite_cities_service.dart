import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/models/favorite_city.dart';

class FavoriteCitiesService {
  static const String _key = 'favorite_cities';

  Future<List<FavoriteCity>> getFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();
    final String? citiesJson = prefs.getString(_key);
    if (citiesJson == null) return [];
    final List<dynamic> citiesList = jsonDecode(citiesJson);
    return citiesList.map((city) => FavoriteCity.fromJson(city)).toList();
  }

  Future<void> addFavoriteCity(FavoriteCity city) async {
    final prefs = await SharedPreferences.getInstance();
    final List<FavoriteCity> cities = await getFavoriteCities();
    cities.add(city);
    await prefs.setString(
      _key,
      jsonEncode(cities.map((c) => c.toJson()).toList()),
    );
  }

  Future<void> removeFavoriteCity(FavoriteCity city) async {
    final prefs = await SharedPreferences.getInstance();
    final List<FavoriteCity> cities = await getFavoriteCities();
    cities.removeWhere((c) => c.name == city.name);
    await prefs.setString(
      _key,
      jsonEncode(cities.map((c) => c.toJson()).toList()),
    );
  }
}

class FavoriteCity {
  final String name;
  final double lat;
  final double lon;

  FavoriteCity({required this.name, required this.lat, required this.lon});

  Map<String, dynamic> toJson() => {'name': name, 'lat': lat, 'lon': lon};

  factory FavoriteCity.fromJson(Map<String, dynamic> json) =>
      FavoriteCity(name: json['name'], lat: json['lat'], lon: json['lon']);
}

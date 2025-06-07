# Weather App

A Flutter application that provides real-time weather information using the OpenWeatherMap API.

## Features

- Search for weather by city name
- Get weather for current location
- Display detailed weather information including:
  - Temperature
  - Weather description
  - Humidity
  - Wind speed
  - Pressure
- Modern Material Design 3 UI
- Responsive layout
- Loading indicators and error handling

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Dart SDK (latest version)
- OpenWeatherMap API key

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/weatherapp.git
```

2. Navigate to the project directory:
```bash
cd weatherapp
```

3. Install dependencies:
```bash
flutter pub get
```

4. Update the API key:
   - Open `lib/constants/constants.dart`
   - Replace `YOUR_API_KEY` with your OpenWeatherMap API key

5. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── constants/
│   └── constants.dart
├── models/
│   └── weather_model.dart
├── screens/
│   └── weather_screen.dart
├── services/
│   └── weather_service.dart
├── widgets/
│   └── weather_card.dart
└── main.dart
```

## Dependencies

- http: ^1.2.0
- geolocator: ^11.0.0
- provider: ^6.1.1
- intl: ^0.19.0
- flutter_dotenv: ^5.1.0
- cached_network_image: ^3.3.1
- flutter_spinkit: ^5.2.0

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- OpenWeatherMap for providing the weather API
- Flutter team for the amazing framework

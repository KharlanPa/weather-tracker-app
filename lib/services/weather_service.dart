import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const String _apiKey = 'c6a2dc45b43043ea850c4b4e406b9235';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Weather> getWeather(String city) async {
    final url = Uri.parse(
      '$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric&lang=ru',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Weather.fromJson(json);
    } else {
      throw Exception('Не удалось загрузить погоду для $city');
    }
  }

  Future<List<String>> searchCities(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse(
      'https://api.openweathermap.org/geo/1.0/direct?q=$query&limit=10&appid=$_apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((city) {
        final name = city['name'] as String;
        final country = city['country'] as String;
        return '$name, $country';
      }).toList();
    } else {
      return [];
    }
  }
}

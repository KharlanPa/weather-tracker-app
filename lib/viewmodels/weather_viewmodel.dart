import 'package:flutter/foundation.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import '../services/storage_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final StorageService _storageService = StorageService();

  List<String> _favoriteCities = [];
  String _selectedCity = 'Москва';
  Weather? _currentWeather;
  Map<String, Weather> _citiesWeather = {};
  bool _isLoading = true;
  bool _isLoadingWeather = false;
  String? _error;

  // Getters
  List<String> get favoriteCities => _favoriteCities;
  String get selectedCity => _selectedCity;
  Weather? get currentWeather => _currentWeather;
  Map<String, Weather> get citiesWeather => _citiesWeather;
  bool get isLoading => _isLoading;
  bool get isLoadingWeather => _isLoadingWeather;
  String? get error => _error;

  // Инициализация - загрузка данных из хранилища
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    final cities = await _storageService.getFavoriteCities();
    final selectedCity = await _storageService.getSelectedCity();

    _favoriteCities = cities;
    _selectedCity = cities.contains(selectedCity) ? selectedCity : cities.first;
    _isLoading = false;
    notifyListeners();

    // Загружаем погоду для выбранного города
    await loadWeatherForSelectedCity();
  }

  // Загрузка погоды для выбранного города
  Future<void> loadWeatherForSelectedCity() async {
    _isLoadingWeather = true;
    _error = null;
    notifyListeners();

    try {
      _currentWeather = await _weatherService.getWeather(_selectedCity);
      _error = null;
    } catch (e) {
      _error = 'Не удалось загрузить данные о погоде';
      _currentWeather = null;
    }

    _isLoadingWeather = false;
    notifyListeners();
  }

  // Загрузка погоды для всех избранных городов
  Future<void> loadWeatherForAllCities() async {
    _citiesWeather = {};
    notifyListeners();

    for (final city in _favoriteCities) {
      try {
        final weather = await _weatherService.getWeather(city);
        _citiesWeather[city] = weather;
        notifyListeners();
      } catch (e) {
        // Пропускаем город при ошибке
      }
    }
  }

  // Выбор города
  void selectCity(String city) {
    _selectedCity = city;
    _storageService.saveSelectedCity(city);
    notifyListeners();
    loadWeatherForSelectedCity();
  }

  // Добавление города в избранное
  void addCity(String city) {
    if (!_favoriteCities.contains(city)) {
      _favoriteCities.add(city);
      _storageService.saveFavoriteCities(_favoriteCities);
      notifyListeners();
    }
  }

  // Удаление города из избранного
  void removeCity(String city) {
    _favoriteCities.remove(city);
    _citiesWeather.remove(city);

    if (_selectedCity == city && _favoriteCities.isNotEmpty) {
      _selectedCity = _favoriteCities.first;
      _storageService.saveSelectedCity(_selectedCity);
      loadWeatherForSelectedCity();
    }

    _storageService.saveFavoriteCities(_favoriteCities);
    notifyListeners();
  }

  // Поиск городов
  Future<List<String>> searchCities(String query) async {
    return await _weatherService.searchCities(query);
  }
}

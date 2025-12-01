import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/search_screen.dart';
import 'services/storage_service.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeatherTracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2196F3)),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final StorageService _storageService = StorageService();

  int _currentIndex = 0;
  String _selectedCity = 'Москва';
  List<String> _favoriteCities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final cities = await _storageService.getFavoriteCities();
    final selectedCity = await _storageService.getSelectedCity();

    setState(() {
      _favoriteCities = cities;
      _selectedCity = cities.contains(selectedCity) ? selectedCity : cities.first;
      _isLoading = false;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _selectCity(String city) {
    setState(() {
      _selectedCity = city;
      _currentIndex = 0;
    });
    _storageService.saveSelectedCity(city);
  }

  void _addCity(String city) {
    if (!_favoriteCities.contains(city)) {
      setState(() {
        _favoriteCities.add(city);
      });
      _storageService.saveFavoriteCities(_favoriteCities);
    }
  }

  void _removeCity(String city) {
    setState(() {
      _favoriteCities.remove(city);
      if (_selectedCity == city && _favoriteCities.isNotEmpty) {
        _selectedCity = _favoriteCities.first;
        _storageService.saveSelectedCity(_selectedCity);
      }
    });
    _storageService.saveFavoriteCities(_favoriteCities);
  }

  Future<void> _openSearchScreen() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
    if (result != null) {
      _addCity(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFE3F2FD),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: _currentIndex == 0
          ? HomeScreen(selectedCity: _selectedCity)
          : FavoritesScreen(
              cities: _favoriteCities,
              selectedCity: _selectedCity,
              onCitySelected: _selectCity,
              onCityRemoved: _removeCity,
              onAddCity: _openSearchScreen,
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: const Color(0xFF2196F3),
        unselectedItemColor: const Color(0xFF757575),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny),
            label: 'Погода',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранное',
          ),
        ],
      ),
    );
  }
}

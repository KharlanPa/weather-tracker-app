import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/search_screen.dart';

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
  int _currentIndex = 0;
  String _selectedCity = 'Москва';
  final List<String> _favoriteCities = ['Москва', 'Санкт-Петербург', 'Казань'];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _selectCity(String city) {
    setState(() {
      _selectedCity = city;
      _currentIndex = 0; // Переключаемся на главный экран
    });
  }

  void _addCity(String city) {
    if (!_favoriteCities.contains(city)) {
      setState(() {
        _favoriteCities.add(city);
      });
    }
  }

  void _removeCity(String city) {
    setState(() {
      _favoriteCities.remove(city);
      if (_selectedCity == city && _favoriteCities.isNotEmpty) {
        _selectedCity = _favoriteCities.first;
      }
    });
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

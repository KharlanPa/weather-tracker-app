import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/search_screen.dart';
import 'viewmodels/weather_viewmodel.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherViewModel()..init(),
      child: MaterialApp(
        title: 'WeatherTracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2196F3)),
          useMaterial3: true,
        ),
        home: const MainScreen(),
      ),
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

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _openSearchScreen() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
    if (result != null) {
      if (mounted) {
        context.read<WeatherViewModel>().addCity(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WeatherViewModel>();

    if (viewModel.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFE3F2FD),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: _currentIndex == 0
          ? const HomeScreen()
          : FavoritesScreen(onAddCity: _openSearchScreen),
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

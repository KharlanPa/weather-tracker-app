import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/weather_viewmodel.dart';

class FavoritesScreen extends StatefulWidget {
  final VoidCallback onAddCity;

  const FavoritesScreen({
    super.key,
    required this.onAddCity,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем погоду для всех городов при открытии экрана
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherViewModel>().loadWeatherForAllCities();
    });
  }

  IconData _getWeatherIcon(String? iconCode) {
    if (iconCode == null) return Icons.help_outline;
    switch (iconCode.substring(0, 2)) {
      case '01':
        return Icons.wb_sunny;
      case '02':
        return Icons.cloud_queue;
      case '03':
      case '04':
        return Icons.cloud;
      case '09':
      case '10':
        return Icons.water_drop;
      case '11':
        return Icons.thunderstorm;
      case '13':
        return Icons.ac_unit;
      case '50':
        return Icons.foggy;
      default:
        return Icons.wb_sunny;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WeatherViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text('Избранные города'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => viewModel.loadWeatherForAllCities(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: widget.onAddCity,
          ),
        ],
      ),
      body: viewModel.favoriteCities.isEmpty
          ? const Center(
              child: Text(
                'Нет избранных городов.\nНажмите + чтобы добавить.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF757575),
                  fontSize: 16,
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: () => viewModel.loadWeatherForAllCities(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: viewModel.favoriteCities.length,
                itemBuilder: (context, index) {
                  final city = viewModel.favoriteCities[index];
                  final weather = viewModel.citiesWeather[city];
                  final isLoading = weather == null;

                  return _buildCityCard(
                    context: context,
                    viewModel: viewModel,
                    name: city,
                    weather: weather,
                    isLoading: isLoading,
                    isSelected: city == viewModel.selectedCity,
                  );
                },
              ),
            ),
    );
  }

  Widget _buildCityCard({
    required BuildContext context,
    required WeatherViewModel viewModel,
    required String name,
    dynamic weather,
    required bool isLoading,
    required bool isSelected,
  }) {
    return Dismissible(
      key: Key(name),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        viewModel.removeCity(name);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$name удалён из избранного')),
        );
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFBBDEFB) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: isSelected
              ? Border.all(color: const Color(0xFF2196F3), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          leading: isLoading
              ? const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  _getWeatherIcon(weather?.icon),
                  size: 40,
                  color: const Color(0xFFFF9800),
                ),
          title: Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
          subtitle: Text(
            weather?.capitalizedDescription ?? 'Загрузка...',
            style: const TextStyle(
              color: Color(0xFF757575),
            ),
          ),
          trailing: Text(
            weather?.temperatureString ?? '--',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2196F3),
            ),
          ),
          onTap: () => viewModel.selectCity(name),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/weather_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  IconData _getWeatherIcon(String iconCode) {
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
        title: const Text('WeatherTracker'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => viewModel.loadWeatherForSelectedCity(),
          ),
        ],
      ),
      body: _buildBody(context, viewModel),
    );
  }

  Widget _buildBody(BuildContext context, WeatherViewModel viewModel) {
    if (viewModel.isLoadingWeather) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (viewModel.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(viewModel.error!, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.loadWeatherForSelectedCity(),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    final weather = viewModel.currentWeather;
    if (weather == null) {
      return const Center(child: Text('Нет данных'));
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.loadWeatherForSelectedCity(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Название города
              Text(
                weather.cityName,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 20),

              // Иконка погоды
              Icon(
                _getWeatherIcon(weather.icon),
                size: 100,
                color: const Color(0xFFFF9800),
              ),
              const SizedBox(height: 20),

              // Температура
              Text(
                weather.temperatureString,
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 10),

              // Описание погоды
              Text(
                weather.capitalizedDescription,
                style: const TextStyle(
                  fontSize: 24,
                  color: Color(0xFF757575),
                ),
              ),
              const SizedBox(height: 40),

              // Дополнительная информация
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoItem(Icons.water_drop, '${weather.humidity}%', 'Влажность'),
                    _buildInfoItem(Icons.air, '${weather.windSpeed.round()} м/с', 'Ветер'),
                    _buildInfoItem(Icons.speed, '${weather.pressure}', 'Давление'),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF2196F3), size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF757575),
          ),
        ),
      ],
    );
  }
}

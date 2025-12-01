import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String selectedCity;

  const HomeScreen({super.key, required this.selectedCity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text('WeatherTracker'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Название города
              Text(
                selectedCity,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 20),

              // Иконка погоды
              const Icon(
                Icons.wb_sunny,
                size: 100,
                color: Color(0xFFFF9800),
              ),
              const SizedBox(height: 20),

              // Температура
              const Text(
                '+15°C',
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 10),

              // Описание погоды
              const Text(
                'Ясно',
                style: TextStyle(
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
                    _buildInfoItem(Icons.water_drop, '60%', 'Влажность'),
                    _buildInfoItem(Icons.air, '5 м/с', 'Ветер'),
                    _buildInfoItem(Icons.speed, '760', 'Давление'),
                  ],
                ),
              ),
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

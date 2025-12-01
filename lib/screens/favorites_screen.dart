import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Моковые данные для отображения
    final cities = [
      {'name': 'Москва', 'temp': '+15°C', 'description': 'Ясно', 'icon': Icons.wb_sunny},
      {'name': 'Санкт-Петербург', 'temp': '+8°C', 'description': 'Облачно', 'icon': Icons.cloud},
      {'name': 'Казань', 'temp': '+12°C', 'description': 'Дождь', 'icon': Icons.water_drop},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text('Избранные города'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Будет реализовано в ЛР5
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final city = cities[index];
          return _buildCityCard(
            name: city['name'] as String,
            temp: city['temp'] as String,
            description: city['description'] as String,
            icon: city['icon'] as IconData,
          );
        },
      ),
    );
  }

  Widget _buildCityCard({
    required String name,
    required String temp,
    required String description,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Icon(
          icon,
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
          description,
          style: const TextStyle(
            color: Color(0xFF757575),
          ),
        ),
        trailing: Text(
          temp,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2196F3),
          ),
        ),
        onTap: () {
          // Будет реализовано в ЛР5
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  final List<String> cities;
  final String selectedCity;
  final Function(String) onCitySelected;
  final Function(String) onCityRemoved;
  final VoidCallback onAddCity;

  const FavoritesScreen({
    super.key,
    required this.cities,
    required this.selectedCity,
    required this.onCitySelected,
    required this.onCityRemoved,
    required this.onAddCity,
  });

  // Моковые данные погоды для городов
  Map<String, Map<String, dynamic>> get _weatherData => {
    'Москва': {'temp': '+15°C', 'description': 'Ясно', 'icon': Icons.wb_sunny},
    'Санкт-Петербург': {'temp': '+8°C', 'description': 'Облачно', 'icon': Icons.cloud},
    'Казань': {'temp': '+12°C', 'description': 'Дождь', 'icon': Icons.water_drop},
    'Новосибирск': {'temp': '+5°C', 'description': 'Снег', 'icon': Icons.ac_unit},
    'Екатеринбург': {'temp': '+7°C', 'description': 'Пасмурно', 'icon': Icons.cloud},
    'Нижний Новгород': {'temp': '+10°C', 'description': 'Ясно', 'icon': Icons.wb_sunny},
    'Челябинск': {'temp': '+6°C', 'description': 'Облачно', 'icon': Icons.cloud},
    'Самара': {'temp': '+11°C', 'description': 'Ясно', 'icon': Icons.wb_sunny},
    'Омск': {'temp': '+3°C', 'description': 'Снег', 'icon': Icons.ac_unit},
    'Ростов-на-Дону': {'temp': '+14°C', 'description': 'Ясно', 'icon': Icons.wb_sunny},
    'Уфа': {'temp': '+9°C', 'description': 'Облачно', 'icon': Icons.cloud},
    'Красноярск': {'temp': '+2°C', 'description': 'Снег', 'icon': Icons.ac_unit},
    'Воронеж': {'temp': '+13°C', 'description': 'Ясно', 'icon': Icons.wb_sunny},
    'Пермь': {'temp': '+4°C', 'description': 'Дождь', 'icon': Icons.water_drop},
    'Волгоград': {'temp': '+16°C', 'description': 'Ясно', 'icon': Icons.wb_sunny},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text('Избранные города'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: onAddCity,
          ),
        ],
      ),
      body: cities.isEmpty
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
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final city = cities[index];
                final weather = _weatherData[city] ?? {
                  'temp': '+10°C',
                  'description': 'Нет данных',
                  'icon': Icons.help_outline,
                };
                return _buildCityCard(
                  context: context,
                  name: city,
                  temp: weather['temp'] as String,
                  description: weather['description'] as String,
                  icon: weather['icon'] as IconData,
                  isSelected: city == selectedCity,
                );
              },
            ),
    );
  }

  Widget _buildCityCard({
    required BuildContext context,
    required String name,
    required String temp,
    required String description,
    required IconData icon,
    required bool isSelected,
  }) {
    return Dismissible(
      key: Key(name),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onCityRemoved(name);
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
          onTap: () => onCitySelected(name),
        ),
      ),
    );
  }
}

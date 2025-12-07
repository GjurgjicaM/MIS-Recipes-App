import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import 'meal_detail_screen.dart';

class RandomMealScreen extends StatefulWidget {
  const RandomMealScreen({super.key});

  @override
  State<RandomMealScreen> createState() => _RandomMealScreenState();
}

class _RandomMealScreenState extends State<RandomMealScreen> {
  Meal? meal;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchRandomMeal();
  }

  void fetchRandomMeal() async {
    final data = await ApiService.getRandomMeal();
    setState(() {
      meal = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Random Meal')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Image.network(meal!.thumbnail),
          const SizedBox(height: 8),
          Text(meal!.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MealDetailScreen(mealId: meal!.id)),
              );
            },
            child: const Text('View Details'),
          ),
        ],
      ),
    );
  }
}

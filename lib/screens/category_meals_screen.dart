import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/api_service.dart';
import '../models/meal.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class CategoryMealsScreen extends StatefulWidget {
  final String category;
  final Future<bool> Function(Meal) toggleFavorite;

  const CategoryMealsScreen({
    super.key,
    required this.category,
    required this.toggleFavorite,
  });

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  List<Meal> meals = [];
  List<Meal> filteredMeals = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchMeals();
  }

  void fetchMeals() async {
    final data = await ApiService.getMealsByCategory(widget.category);

    final favSnapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .get();

    final favoriteIds = favSnapshot.docs.map((doc) => doc.id).toSet();

    for (var meal in data) {
      meal.isFavorite = favoriteIds.contains(meal.id);
    }

    setState(() {
      meals = data;
      filteredMeals = data;
      loading = false;
    });
  }

  void searchMeals(String query) async {
    if (query.isEmpty) {
      setState(() {
        filteredMeals = meals;
      });
    } else {
      final results = await ApiService.searchMeals(query);

      final favSnapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .get();
      final favoriteIds = favSnapshot.docs.map((doc) => doc.id).toSet();

      for (var meal in results) {
        meal.isFavorite = favoriteIds.contains(meal.id);
      }

      setState(() {
        filteredMeals = results
            .where((m) => m.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search meals..',
                border: OutlineInputBorder(),
              ),
              onChanged: searchMeals,
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.70,
              ),
              itemCount: filteredMeals.length,
              itemBuilder: (_, index) {
                final meal = filteredMeals[index];
                return MealCard(
                  meal: meal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MealDetailScreen(mealId: meal.id),
                      ),
                    );
                  },
                  onToggleFavorite: (meal) async {
                    await widget.toggleFavorite(meal);
                    // Refresh state after toggle
                    setState(() {});
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
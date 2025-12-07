import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/api_service.dart';
import '../models/category.dart';
import '../models/meal.dart';
import '../widgets/category_card.dart';
import 'category_meals_screen.dart';
import 'random_meal_screen.dart';
import 'favorites_screen.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> categories = [];
  List<Category> filteredCategories = [];
  bool loading = true;

  Future<bool> toggleFavorite(Meal meal) async {
    final favRef = FirebaseFirestore.instance.collection('favorites').doc(meal.id);

    final newFavoriteState = !meal.isFavorite;

    setState(() {
      meal.isFavorite = newFavoriteState;
    });

    try {
      if (newFavoriteState) {
        await favRef.set(meal.toJson());
        print('Added ${meal.name} to Firestore');
        return true;
      } else {
        await favRef.delete();
        print('Removed ${meal.name} from Firestore');
        return false;
      }
    } catch (e) {
      setState(() {
        meal.isFavorite = !newFavoriteState;
      });
      print('Error updating favorite: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
      return !newFavoriteState;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() async {
    final data = await ApiService.getCategories();
    setState(() {
      categories = data;
      filteredCategories = data;
      loading = false;
    });
  }

  void filterCategories(String query) {
    final filtered = categories
        .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredCategories = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: 'Test Daily Notification',
            onPressed: () async {
              await NotificationService().showDailyMealNotification();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification sent!')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RandomMealScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FavoritesScreen(onToggleFavorite: toggleFavorite),
                ),
              );
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                  hintText: 'Search categories..',
                  border: OutlineInputBorder()),
              onChanged: filterCategories,
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: filteredCategories.length,
              itemBuilder: (_, index) {
                return CategoryCard(
                  category: filteredCategories[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryMealsScreen(
                          category: filteredCategories[index].name,
                          toggleFavorite: toggleFavorite,
                        ),
                      ),
                    );
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
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meal.dart';
import '../widgets/meal_card.dart';

class FavoritesScreen extends StatelessWidget {
  final Future<bool> Function(Meal meal) onToggleFavorite;

  const FavoritesScreen({
    super.key,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Meals")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('favorites').snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No favorites added yet",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final favMeals = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Meal.fromFirestore(data, doc.id);
          }).toList();

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.70,
            ),
            itemCount: favMeals.length,
            itemBuilder: (_, i) {
              return MealCard(
                meal: favMeals[i],
                onTap: () {
                },
                onToggleFavorite: (meal) async {
                  await onToggleFavorite(meal);
                },
              );
            },
          );
        },
      ),
    );
  }
}
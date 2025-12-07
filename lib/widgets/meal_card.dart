import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onTap;
  final Future<void> Function(Meal) onToggleFavorite;

  const MealCard({
    super.key,
    required this.meal,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.all(6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: Image.network(
                  meal.thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(6, 4, 6, 2),
              child: Text(
                meal.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
              child: Text(
                meal.instructions.length > 40
                    ? '${meal.instructions.substring(0, 40)}...'
                    : meal.instructions,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black54,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            SizedBox(
              height: 32,
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
                    meal.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: meal.isFavorite ? Colors.red : Colors.grey,
                    size: 20,
                  ),
                  onPressed: () => onToggleFavorite(meal),
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
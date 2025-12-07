class Meal {
  final String id;
  final String name;
  final String thumbnail;
  final String instructions;
  final List<String> ingredients;
  final String? youtube;
  bool isFavorite;

  Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.instructions = '',
    this.ingredients = const [],
    this.youtube,
    this.isFavorite = false,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add('$ingredient - $measure');
      }
    }
    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
      instructions: json['strInstructions'] ?? '',
      ingredients: ingredients,
      youtube: json['strYoutube'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // include id for safety
      'name': name,
      'thumbnail': thumbnail,
      'instructions': instructions,
      'ingredients': ingredients,
      'youtube': youtube,
    };
  }

  factory Meal.fromFirestore(Map<String, dynamic> data, String docId) {
    return Meal(
      id: docId,
      name: data['name'] ?? '',
      thumbnail: data['thumbnail'] ?? '',
      instructions: data['instructions'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      youtube: data['youtube'],
      isFavorite: true,
    );
  }
}

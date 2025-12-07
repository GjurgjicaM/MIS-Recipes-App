import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';

class ApiService {
  static const baseUrl = 'https://www.themealdb.com/api/json/v1/1/';

  static Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('${baseUrl}categories.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['categories'] as List;
      return data.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<List<Meal>> getMealsByCategory(String category) async {
    final response = await http.get(Uri.parse('${baseUrl}filter.php?c=$category'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['meals'] as List;
      return data.map((e) => Meal.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  static Future<Meal> getMealDetail(String id) async {
    final response = await http.get(Uri.parse('${baseUrl}lookup.php?i=$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['meals'][0];
      return Meal.fromJson(data);
    } else {
      throw Exception('Failed to load meal detail');
    }
  }

  static Future<Meal> getRandomMeal() async {
    final response = await http.get(Uri.parse('${baseUrl}random.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['meals'][0];
      return Meal.fromJson(data);
    } else {
      throw Exception('Failed to load random meal');
    }
  }

  static Future<List<Meal>> searchMeals(String query) async {
    final response = await http.get(Uri.parse('${baseUrl}search.php?s=$query'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['meals'];
      if (data != null) {
        return (data as List).map((e) => Meal.fromJson(e)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to search meals');
    }
  }
}
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../models/meal.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  const MealDetailScreen({super.key, required this.mealId});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  Meal? meal;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchMealDetail();
  }

  void fetchMealDetail() async {
    final data = await ApiService.getMealDetail(widget.mealId);
    setState(() {
      meal = data;
      loading = false;
    });
  }

  void openYoutube(String url) async {
    if (!url.startsWith('http')) {
      url = 'https://$url';
    }

    final uri = Uri.parse(url);

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print("Could not launch $url: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open link")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(meal?.name ?? 'Loading...')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              meal!.thumbnail,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              meal!.name,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Instructions:',
                style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 4),
            Text(meal!.instructions),
            const SizedBox(height: 16),
            const Text('Ingredients:',
                style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 4),
            ...meal!.ingredients.map((i) => Text("• $i")),
            const SizedBox(height: 16),
            if (meal!.youtube != null && meal!.youtube!.isNotEmpty)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => openYoutube(meal!.youtube!),
                  icon: const Icon(Icons.play_circle_fill),
                  label: const Text('Watch on YouTube'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

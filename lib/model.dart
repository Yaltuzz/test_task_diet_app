// Model danych dla wartości odżywczych
class NutritionValues {
  final int calories;
  final int proteins;
  final int carbs;
  final int fat;

  NutritionValues({
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fat,
  });

  @override
  String toString() {
    return 'Calories: $calories kcal, Proteins: $proteins g, Carbs: $carbs g, Fat: $fat g';
  }
}

// Enum dla rozmiarów
enum MealSize { S, M, L }

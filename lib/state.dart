// Stan przechowujący wybrany rozmiar
import 'package:invo/model.dart';
import 'package:riverpod/riverpod.dart';

class MealSizeNotifier extends StateNotifier<MealSize> {
  MealSizeNotifier() : super(MealSize.S);

  void setSize(MealSize size) {
    state = size;
  }
}

final mealSizeProvider = StateNotifierProvider<MealSizeNotifier, MealSize>(
  (ref) => MealSizeNotifier(),
);

final nutritionValuesProvider = Provider<NutritionValues>((ref) {
  final size = ref.watch(mealSizeProvider);

  switch (size) {
    case MealSize.S:
      return NutritionValues(calories: 430, proteins: 45, carbs: 55, fat: 18);
    case MealSize.M:
      return NutritionValues(calories: 607, proteins: 57, carbs: 68, fat: 27);
    case MealSize.L:
      return NutritionValues(calories: 832, proteins: 69, carbs: 85, fat: 35);
  }
});

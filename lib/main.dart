import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invo/model.dart';
import 'package:invo/state.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invo task',
      home: const MyHomePage(title: 'Szczegóły posiłku'),
    );
  }
}

class AppTextStyles {
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.2,
    color: Colors.white,
  );

  static const TextStyle mealTitle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 24,
    height: 1.2,
    letterSpacing: 0.04,
    color: Colors.black,
  );

  static const TextStyle mealDescription = TextStyle(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.01,
    color: Color(0xFF404040),
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 18,
    height: 1.3,
    letterSpacing: 0.04,
    color: Colors.black,
  );

  static const TextStyle sectionContent = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.5,
    letterSpacing: 0.4,
    color: Color(0xFF404040),
  );

  static const TextStyle allergenText = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.0,
    letterSpacing: 0.4,
    color: Color(0xFF404040),
  );

  static const TextStyle sizeButtonText = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.0,
    letterSpacing: 0,
    color: Colors.black,
  );

  static const TextStyle nutritionTitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
  );

  static const TextStyle nutritionValue = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );
}

class BlurredAppBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const BlurredAppBar({super.key, required this.title, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            backgroundBlendMode: BlendMode.multiply,
            gradient: LinearGradient(
              colors: [
                const Color(0xFF5D5D5D).withAlpha(0),
                const Color(0xFF5D5D5D),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Positioned.fill(
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),
              Expanded(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),
            ],
          ),
        ),
        AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: Image.asset(
            'assets/img/back_icon.png',
            width: 20,
            height: 20,
          ),
          title: Text(title, style: AppTextStyles.appBarTitle),
        ),
      ],
    );
  }
}

class AnimatedNutritionValue extends ImplicitlyAnimatedWidget {
  final String value;
  final TextStyle style;

  const AnimatedNutritionValue({
    super.key,
    required this.value,
    required this.style,
    super.duration = const Duration(milliseconds: 300),
    super.curve = Curves.easeInOut,
  });

  @override
  ImplicitlyAnimatedWidgetState<AnimatedNutritionValue> createState() =>
      _AnimatedNutritionValueState();
}

class _AnimatedNutritionValueState
    extends AnimatedWidgetBaseState<AnimatedNutritionValue> {
  StringTween? _valueTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _valueTween =
        visitor(
              _valueTween,
              widget.value,
              (dynamic value) => StringTween(begin: value as String?),
            )
            as StringTween?;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _valueTween?.evaluate(animation) ?? widget.value,
      style: widget.style,
    );
  }
}

class StringTween extends Tween<String?> {
  StringTween({super.begin, super.end});

  @override
  String? lerp(double t) {
    if (t < 0.5) return begin;
    return end;
  }
}

class SizeButton extends StatelessWidget {
  final String size;
  final bool isSelected;
  final VoidCallback? onPressed;

  const SizeButton({
    super.key,
    required this.size,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: !isSelected
              ? Border.all(width: 1.0, color: const Color(0xFFC8C8C8))
              : null,
          color: isSelected ? const Color(0xFF5F9F26) : Colors.transparent,
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFADC057),
                    Color(0xFF8BBD60),
                    Color(0xFF7EBC49),
                    Color(0xFF6CA936),
                    Color(0xFF5F9F26),
                  ],
                )
              : null,
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: AppTextStyles.sizeButtonText.copyWith(
              color: isSelected ? Colors.white : Colors.black,
            ),
            child: Text('Rozmiar $size'),
          ),
        ),
      ),
    );
  }
}

class NutritionCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const NutritionCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Container(
          height: 112,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 16),
              Text(title, style: AppTextStyles.nutritionTitle),
              Expanded(child: Container()),
              AnimatedNutritionValue(
                value: value,
                style: AppTextStyles.nutritionValue,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        Positioned(
          bottom: 3,
          left: 3,
          right: 3,
          child: Container(
            height: 77,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.0),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color.withAlpha(0),
                  color.withAlpha((0.2 * 255).toInt()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AllergenItem extends StatelessWidget {
  final String asset;
  final String text;

  const AllergenItem({super.key, required this.asset, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(asset, width: 16, height: 16),
        const SizedBox(width: 4.0),
        Text(text, style: AppTextStyles.allergenText),
      ],
    );
  }
}

class AnimatedNutritionSection extends ConsumerWidget {
  const AnimatedNutritionSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSize = ref.watch(mealSizeProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Builder(
        key: ValueKey(currentSize),
        builder: (context) {
          final nutrition = ref.watch(nutritionValuesProvider);

          return Row(
            children: [
              Expanded(
                child: NutritionCard(
                  title: 'Calories',
                  value: '${nutrition.calories} kcal',
                  color: const Color(0xFF000000),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: NutritionCard(
                  title: 'Proteins',
                  value: '${nutrition.proteins}g',
                  color: const Color(0xFF2EA6D9),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: NutritionCard(
                  title: 'Carbs',
                  value: '${nutrition.carbs}g',
                  color: const Color(0xFFE79A42),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: NutritionCard(
                  title: 'Fat',
                  value: '${nutrition.fat}g',
                  color: const Color(0xFFE7C747),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MealContentCard extends StatelessWidget {
  const MealContentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.03 * 255).toInt()),
            blurRadius: 20,
            spreadRadius: -10,
            offset: Offset.zero,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
          child: Container(
            color: Colors.white.withAlpha((0.32 * 255).toInt()),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
            child: const MealContent(),
          ),
        ),
      ),
    );
  }
}

class MealContent extends ConsumerWidget {
  const MealContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSize = ref.watch(mealSizeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kanapka z wege szarpaną kaczką', style: AppTextStyles.mealTitle),
        const SizedBox(height: 12),
        Text(
          'Odkryj nowy wymiar smaku z kanapką z wege szarpaną kaczką – idealnym połączeniem soczystej, roślinnej alternatywy i chrupiącego pieczywa. Każdy kęs to harmonia przypraw, tekstur i świeżości. Zainspiruj się i zasmakuj w lepszym wyborze!',
          style: AppTextStyles.mealDescription,
        ),
        const SizedBox(height: 32),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizeButton(
              size: 'S',
              isSelected: currentSize == MealSize.S,
              onPressed: () {
                ref.read(mealSizeProvider.notifier).setSize(MealSize.S);
              },
            ),
            const SizedBox(width: 8),
            SizeButton(
              size: 'M',
              isSelected: currentSize == MealSize.M,
              onPressed: () {
                ref.read(mealSizeProvider.notifier).setSize(MealSize.M);
              },
            ),
            const SizedBox(width: 8),
            SizeButton(
              size: 'L',
              isSelected: currentSize == MealSize.L,
              onPressed: () {
                ref.read(mealSizeProvider.notifier).setSize(MealSize.L);
              },
            ),
          ],
        ),
        const SizedBox(height: 24.0),

        const AnimatedNutritionSection(),
        const SizedBox(height: 32.0),

        Text('Składniki', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 8.0),
        Text(
          'Chrupiące pieczywo, wegańska szarpana kaczka, świeża sałata, ogórek, pomidor, sos barbecue wegański',
          style: AppTextStyles.sectionContent,
        ),
        const SizedBox(height: 32.0),

        Text('Alergeny', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 8.0),
        Row(
          children: [
            const AllergenItem(
              asset: 'assets/img/Alergens.png',
              text: 'Pszenica',
            ),
            const SizedBox(width: 8.0),
            const AllergenItem(asset: 'assets/img/Carbs.png', text: 'Gluten'),
            const SizedBox(width: 8.0),
            const AllergenItem(
              asset: 'assets/img/milk-bottle.png',
              text: 'Mleko',
            ),
          ],
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFE2E2E2),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: BlurredAppBar(
          title: widget.title,
          onBackPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.47,
            child: Image.asset(
              'assets/img/header_meal.jpg',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

          SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SizedBox(
                  height:
                      MediaQuery.of(context).padding.top + kToolbarHeight + 16,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.28),
                const MealContentCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

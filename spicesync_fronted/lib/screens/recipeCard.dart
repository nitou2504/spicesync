import 'package:flutter/material.dart';
import '/models/recipe.dart';
import '/config/colors.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // ClipRRect for rounded corners on the image
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              recipe.imageUrl!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              recipe.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor,
              ),
            ),
          ),
          // Scrollable list view to display recipe information
          Expanded(
            child: ListView(
              children: [
                // Center(
                //   child: buildPrepCookServe(context, recipe.prepTime, recipe.cookTime, recipe.servings),
                //   ),
                buildPrepCookServe(context, recipe.prepTime, recipe.cookTime, recipe.servings),
                SizedBox(height: 10.0),
                buildIngredientsList(context, 'Ingredients:', recipe.ingredientsList),
                SizedBox(height: 10.0),
                buildMethodList(context, recipe.methodParts),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row buildPrepCookServe(BuildContext context, String? prepTime, String? cookTime, String? servings) {
  return Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PREP TIME', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal)),
            Text(prepTime?? 'NA', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('COOK TIME', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal)),
            Text(cookTime?? 'NA', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SERVINGS', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal)),
            Text(servings?? 'NA', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ],
  );
}


  Widget buildRecipeInfoRow(BuildContext context, String label, String? value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 10.0),
        Text(value ?? 'NA'),
      ],
    );
  }

  Widget buildIngredientsList(BuildContext context, String label, List<dynamic> ingredients) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.secondaryColor
        ),
      ),
      SizedBox(height: 5.0),
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: ingredients.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0), // Adjust padding as needed
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('•', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.secondaryColor)), // Bullet point
                SizedBox(width: 8.0), // Space between bullet and text
                Expanded(
                  child: Text(
                    ingredients[index] as String,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ],
  );
}

  Widget buildMethodList(BuildContext context, List<dynamic> methods) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Method:',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.secondaryColor,
        ),
      ),
      SizedBox(height: 5.0),
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: methods.length,
        itemBuilder: (context, index) {
          String partName = methods[index][0].isEmpty? "" : methods[index][0];
          List<dynamic> steps = methods[index][1];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (partName.isNotEmpty)
                Text(
                  partName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              SizedBox(height: 5.0),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: steps.length,
                itemBuilder: (context, stepIndex) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0), // Padding between steps
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${stepIndex + 1}',
                          style: TextStyle(
                            color: AppColors.secondaryColor, // Orange color for the index
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8.0), // Space between index and step text
                        Expanded(
                          child: Text(
                            steps[stepIndex],
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    ],
  );
}
}

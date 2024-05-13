import 'package:flutter/material.dart';
import '/models/recipe.dart';
import '/config/colors.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;

  const RecipeCard({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  // Assuming you have a list to hold the checkbox values for ingredients
  List<bool> ingredientCheckboxes = [];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(12.0),
              children: [
                if (widget.recipe.imageUrl!=null)
                  ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget.recipe.imageUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),                
                ),
                SizedBox(height: 10.0),
                buildPrepCookServe(context, widget.recipe.prepTime, widget.recipe.cookTime, widget.recipe.servings),
                SizedBox(height: 10.0),
                buildIngredientsList(context, 'Ingredients:', widget.recipe.ingredientsList),
                SizedBox(height: 10.0),
                buildMethodList(context, widget.recipe.methodParts),
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
        Text(value?? 'NA'),
      ],
    );
  }

  Widget buildIngredientsList(BuildContext context, String label, List<dynamic> ingredients) {
  // Initialize ingredientCheckboxes with the correct length
  if (ingredientCheckboxes.length!= ingredients.length) {
    ingredientCheckboxes = List<bool>.filled(ingredients.length, false);
  }

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
          // Check if the ingredients list is not null and has an element at the current index
          if (ingredients[index]!= null) {
            return CheckboxListTile(
              // make the background color of the checkbox transparent
              activeColor: AppColors.secondaryColor,
              title: Text(
                ingredients[index] as String,
                style: TextStyle(fontSize: 18),
              ),
              value: ingredientCheckboxes[index], // Use the list to hold checkbox values
              onChanged: (bool? value) {
                setState(() {
                  ingredientCheckboxes[index] = value!; // Update the state
                });
              },
            );
          } else {
            // Handle the case where the ingredients list is empty or null
            return SizedBox.shrink(); // Return an empty widget
          }
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
import 'package:flutter/material.dart';
import '/models/recipe.dart'; // Adjust the import path as necessary
import '/config/colors.dart'; // Adjust the import path as necessary

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Recipe>> _latestRecipes;
  final ScrollController _scrollController = ScrollController();
  int _offset = 0;
  int _batchSize = 6;
  List<Recipe> _allRecipes = [];
  int _currentIndex = 0; // To keep track of the current index of the BottomNavigationBar

  @override
  void initState() {
    super.initState();
    _loadRecipes();
    _scrollController.addListener(_onScroll);
  }

  bool recipesAvailable = true;

  void _loadRecipes() async {
    setState(() {
      _latestRecipes = Recipe.loadLatestRecipes(offset: _offset, batch_size: _batchSize);
    });

    _offset += _batchSize;
    _latestRecipes.then((newRecipes) {
      if (newRecipes.isEmpty) {
        setState(() {
          recipesAvailable = false;
        });
        return;
      }
      if (_allRecipes.length >= 60) {
        // Sanity check to prevent infinite loop
        _offset = 0;
        _batchSize = 0;
        return;
      }
      setState(() {
        _allRecipes.addAll(newRecipes); // Merge new recipes with existing ones
      });
    });
  }

  void _onScroll() {
    // Check if the current scroll position is at the bottom of the list
    if (_scrollController.position.atEdge) {
      // If the current position is at the bottom, load more recipes
      if (_scrollController.position.pixels!= 0 && recipesAvailable) {
        _loadRecipes();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollEndNotification) {
            _loadRecipes();
          }
          return true;
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(8.0), // Optional: Add padding around the grid
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 8.0, // Space between columns
            mainAxisSpacing: 8.0, // Space between rows
            childAspectRatio: 1 / 1.5, // Aspect ratio of the grid items
          ),
          itemCount: _allRecipes.length,
          itemBuilder: (context, index) {
            return Recipe.makeRecipeCard(context, _allRecipes[index]);
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: AppColors.textColor), // Set icon color
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category, color: AppColors.textColor), // Set icon color
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: AppColors.textColor), // Set icon color
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: AppColors.textColor), // Set icon color
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: AppColors.textColor), // Set icon color
            label: 'User',
          ),
        ],

        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Handle navigation based on the index
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
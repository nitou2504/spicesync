import 'package:flutter/material.dart';
import '/models/recipe.dart'; // Adjust the import path as necessary
import '/config/colors.dart'; // Adjust the import path as necessary
import '/screens/recipeCardScreen.dart'; // Adjust the import path as necessary
import '/models/tags.dart'; // Adjust the import path as necessary

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
  NavigationItem _currentScreen = NavigationItem.home;

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
      // appBar: AppBar(
      //   title: Text('Latest Recipes'),
      // ),
      body: _buildCurrentScreen(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreen) {
      case NavigationItem.home:
        return Scaffold(
          appBar: AppBar(
            title: Text('Latest Recipes'),
          ),
          body: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollEndNotification) {
                _loadRecipes();
                return true;
              }
              return false;
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1 / 1.5,
              ),
              itemCount: _allRecipes.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeCardScreen(recipe: _allRecipes[index]),
                      ),
                    );
                  },
                  child: Recipe.makeRecipeCard(context, _allRecipes[index]),
                );
              },
            ),
          ),
          // bottomNavigationBar: _buildBottomNavigationBar(),
  );
      case NavigationItem.categories:
  case NavigationItem.categories:
  return FutureBuilder<List<String>>(
    future: Tags.getTagNames(),
    builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
      if (snapshot.hasData) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Categories'),
          ),
          body: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index]),
                onTap: () async {
                  List<Recipe> recipes = await Recipe.loadRecipesPerTag(snapshot.data![index]);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text('${snapshot.data![index]} Recipes'),
                        ),
                        body: GridView.builder(
                          padding: const EdgeInsets.all(8.0),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 1 / 1.5,
                          ),
                          itemCount: recipes.length,
                          itemBuilder: (context, index) {
                            return Recipe.makeRecipeCard(context, recipes[index]);
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      // By default, show a loading spinner.
      return Center(child: CircularProgressIndicator());
    },
  );  
      case NavigationItem.search:
        return Center(child: Text('Search Screen'));
      case NavigationItem.favorites:
        return Center(child: Text('Favorites Screen'));
      case NavigationItem.user:
        return Center(child: Text('User Screen'));
      default:
        return Center(child: Text('Home Screen'));
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: Colors.grey,
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
          _currentScreen = NavigationItem.values[index];
        });
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'User',
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

enum NavigationItem { home, categories, search, favorites, user }
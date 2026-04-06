import 'package:flutter/material.dart';

void main() {
  runApp(RecipeApp());
}

class RecipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RecipeHomePage(),
    );
  }
}

// Model class
class Recipe {
  String name;
  String ingredients;
  String steps;

  Recipe({
    required this.name,
    required this.ingredients,
    required this.steps,
  });
}

class RecipeHomePage extends StatefulWidget {
  @override
  _RecipeHomePageState createState() => _RecipeHomePageState();
}

class _RecipeHomePageState extends State<RecipeHomePage> {
  List<Recipe> recipes = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController stepsController = TextEditingController();

  void addRecipe() {
    if (nameController.text.isEmpty ||
        ingredientsController.text.isEmpty ||
        stepsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter all details")),
      );
      return;
    }

    setState(() {
      recipes.add(Recipe(
        name: nameController.text,
        ingredients: ingredientsController.text,
        steps: stepsController.text,
      ));

      nameController.clear();
      ingredientsController.clear();
      stepsController.clear();
    });
  }

  void editRecipe(int index) {
    nameController.text = recipes[index].name;
    ingredientsController.text = recipes[index].ingredients;
    stepsController.text = recipes[index].steps;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Recipe"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: ingredientsController,
                  decoration: InputDecoration(labelText: "Ingredients"),
                ),
                TextField(
                  controller: stepsController,
                  decoration: InputDecoration(labelText: "Steps"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  recipes[index].name = nameController.text;
                  recipes[index].ingredients =
                      ingredientsController.text;
                  recipes[index].steps = stepsController.text;
                });
                Navigator.pop(context);
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void viewRecipe(Recipe recipe) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(recipe.name),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ingredients:", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(recipe.ingredients),
                SizedBox(height: 10),
                Text("Steps:", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(recipe.steps),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void deleteRecipe(int index) {
    setState(() {
      recipes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe Manager"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Recipe Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: ingredientsController,
                  decoration: InputDecoration(
                    labelText: "Ingredients",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: stepsController,
                  decoration: InputDecoration(
                    labelText: "Steps",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: addRecipe,
                  child: Text("Add Recipe"),
                ),
              ],
            ),
          ),
          Expanded(
            child: recipes.isEmpty
                ? Center(child: Text("No recipes added"))
                : ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(recipes[index].name),
                          onTap: () => viewRecipe(recipes[index]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => editRecipe(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => deleteRecipe(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

void main() {
  runApp(EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class Product {
  String name;
  String category;
  String description;
  double price;

  Product(this.name, this.category, this.description, this.price);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = "Electronics";
  Product? selectedProduct;

  List<String> categories = [
    "Electronics",
    "Clothing",
    "Home Decor",
    "Beauty",
    "Books"
  ];

  List<Product> products = [
    // Electronics
    Product("Laptop", "Electronics", "High performance laptop", 75000),
    Product("Smartphone", "Electronics", "Latest Android phone", 25000),
    Product("Headphones", "Electronics", "Noise cancelling", 5000),
    Product("Smart Watch", "Electronics", "Fitness tracking", 8000),

    // Clothing
    Product("T-Shirt", "Clothing", "Cotton t-shirt", 500),
    Product("Jeans", "Clothing", "Slim fit jeans", 1500),
    Product("Jacket", "Clothing", "Winter jacket", 2500),
    Product("Sneakers", "Clothing", "Stylish shoes", 3000),

    // Home Decor
    Product("Sofa", "Home Decor", "Luxury sofa", 20000),
    Product("Lamp", "Home Decor", "Decorative lamp", 1200),
    Product("Wall Art", "Home Decor", "Modern painting", 3000),
    Product("Table", "Home Decor", "Wooden table", 5000),

    // Beauty
    Product("Lipstick", "Beauty", "Long lasting", 600),
    Product("Face Cream", "Beauty", "Skin care", 800),
    Product("Perfume", "Beauty", "Fragrance", 2000),
    Product("Shampoo", "Beauty", "Hair care", 400),

    // Books
    Product("Novel", "Books", "Fiction story", 300),
    Product("Biography", "Books", "Life story", 450),
    Product("Science Book", "Books", "Educational", 700),
    Product("Comics", "Books", "Fun reading", 200),
  ];

  @override
  Widget build(BuildContext context) {
    List<Product> filtered =
        products.where((p) => p.category == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("My Store"),
        backgroundColor: Colors.black,
      ),

      body: Row(
        children: [

          // SIDEBAR
          Container(
            width: 200,
            color: Colors.grey[200],
            child: ListView(
              children: categories.map((cat) {
                return ListTile(
                  title: Text(cat),
                  selected: selectedCategory == cat,
                  selectedTileColor: Colors.blue[100],
                  onTap: () {
                    setState(() {
                      selectedCategory = cat;
                      selectedProduct = null;
                    });
                  },
                );
              }).toList(),
            ),
          ),

          // MAIN CONTENT
          Expanded(
            child: selectedProduct == null
                ? GridView.builder(
                    padding: EdgeInsets.all(15),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final product = filtered[index];

                      return Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedProduct = product;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.shopping_bag,
                                    size: 60, color: Colors.blue),

                                Text(product.name,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),

                                Text("₹ ${product.price}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.green)),

                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedProduct = product;
                                    });
                                  },
                                  child: Text("View"),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )

                // PRODUCT DETAIL PAGE
                : Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(selectedProduct!.name,
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 20),

                        Text("Price: ₹ ${selectedProduct!.price}",
                            style: TextStyle(
                                fontSize: 20, color: Colors.green)),

                        SizedBox(height: 20),

                        Text(selectedProduct!.description,
                            style: TextStyle(fontSize: 18)),

                        SizedBox(height: 30),

                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedProduct = null;
                            });
                          },
                          child: Text("Back"),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
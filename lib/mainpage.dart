import 'package:dealsdray/homepage.dart';
import 'package:flutter/material.dart';
import 'fetch_products.dart'; // Ensure this path matches the location of your `fetch_products.dart`
import 'product.dart'; // Ensure this path matches the location of your `product.dart`

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));
          },
        ),
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search here',
            prefixIcon: Icon(Icons.search, color: Colors.black),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // KYC Banner
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.purple[200],
                child: ListTile(
                  title: Text('KYC Pending'),
                  subtitle: Text('You need to provide the required documents for your account activation.'),
                  trailing: TextButton(
                    onPressed: () {},
                    child: Text('Click Here', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
            // Categories Row
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryIcon(Icons.phone_iphone, 'Mobile'),
                  _buildCategoryIcon(Icons.laptop, 'Laptop'),
                  _buildCategoryIcon(Icons.camera_alt, 'Camera'),
                  _buildCategoryIcon(Icons.tv, 'LED'),
                ],
              ),
            ),
            // Exclusive for You Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Exclusive For You', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            FutureBuilder<List<Product>>(
              future: fetchProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No products available'));
                }

                final products = snapshot.data!;

                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _buildProductCard(product.icon, product.offer, product.label);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: 'Deals'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.chat),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue.shade100,
          child: Icon(icon, color: Colors.blue, size: 30),
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.black)),
      ],
    );
  }

  Widget _buildProductCard(String icon, String offer, String label) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Image.network(icon, height: 120, width: 120, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(offer, style: TextStyle(color: Colors.green)),
                Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product.dart'; // Ensure this path matches the location of your `product.dart`

Future<List<Product>> fetchProducts() async {
  try {
    final response = await http.get(Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/home/withoutPrice'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      if (json['status'] == 1 && json['data'] != null && json['data']['products'] != null) {
        final List<dynamic> productsJson = json['data']['products'];
        return productsJson.map((data) => Product.fromJson(data)).toList();
      } else {
        print('Products key missing or malformed JSON');
        return [];
      }
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  } catch (e) {
    print('Exception: $e');
    throw Exception('Failed to load products: $e');
  }
}

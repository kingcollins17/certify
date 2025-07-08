// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String brand;
  final String sku;
  final double weight;
  final Dimensions dimensions;
  final String warrantyInformation;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      price: json['price'].toDouble(),
      discountPercentage: json['discountPercentage'].toDouble(),
      rating: json['rating'].toDouble(),
      stock: json['stock'],
      tags: List<String>.from(json['tags']),
      brand: json['brand'],
      sku: json['sku'],
      weight: json['weight'].toDouble(),
      dimensions: Dimensions.fromJson(json['dimensions']),
      warrantyInformation: json['warrantyInformation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'tags': tags,
      'brand': brand,
      'sku': sku,
      'weight': weight,
      'dimensions': dimensions.toJson(),
      'warrantyInformation': warrantyInformation,
    };
  }
}

class Dimensions {
  final double width;
  final double height;
  final double depth;

  Dimensions({required this.width, required this.height, required this.depth});

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      width: json['width'].toDouble(),
      height: json['height'].toDouble(),
      depth: json['depth'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'width': width, 'height': height, 'depth': depth};
  }
}

void main() async {
  print('Testing http package...');
  await fetchProductsWithDio();
  // print('\nTesting dio package...');
  // await fetchProductsWithDio();
}

String formatJson(json) {
  return JsonEncoder.withIndent('   ').convert(json);
}

Future<String> signIn(String email, String password) async {
  final url = Uri.parse('https://certify.kode.camp/sign-up');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/xxx-urlformencoded'},
    body: jsonEncode({'email': email, 'password': password}),
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['token'].toString();
  } else {
    throw Exception('Email or password incorrect');
  }
}

Future<List<Product>> fetchProducts() async {
  final url = Uri.parse('https://dummyjson.com/products');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    print(response.body.runtimeType);
    final data = jsonDecode(response.body);
    print(data.runtimeType);
    final products = data['products'];
    print('Fetched ${products.length} products with http');
    print(formatJson(products[0]));
    return (products as List).map((json) => Product.fromJson(json)).toList();
    // print first product
  } else {
    throw Exception('Request unsuccessful');
    // print('HTTP request failed with status: ${response.statusCode}');
  }
}

Future<void> fetchProductsWithDio() async {
  final dio = Dio(BaseOptions(validateStatus: (status) => status == 200));

  try {
    final response = await dio.get('https://dummyjson.com/products');

    if (response.statusCode == 200) {
      final data = response.data;
      final products = data['products'];
      print('Fetched ${products.length} products with Dio');
      print(products[0]); // print first product
    } else {
      print('Dio request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('Dio error occurred: $e');
  }
}

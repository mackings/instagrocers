class Product {
  final String id;
  final String name;
  final ProductCategory category;
  final Store retailer;
  final double price;
  final int stockQuantity;
  final String imageUrl;
  final String storeLogo;
  final String description;
  final bool availability;
  final String weight;
  final String brand;
  final DateTime expiryDate;
  final List<String> ingredients;
  final List<String> allergens;
  final String packaging;
  final bool organic;
  final bool vegan;
  final bool halal;
  final bool kosher;
  final double discountPrice;
  final bool isOnSale;
  final double averageRating;
  final List<dynamic> reviews;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.retailer,
    required this.price,
    required this.stockQuantity,
    required this.imageUrl,
    required this.storeLogo,
    required this.description,
    required this.availability,
    required this.weight,
    required this.brand,
    required this.expiryDate,
    required this.ingredients,
    required this.allergens,
    required this.packaging,
    required this.organic,
    required this.vegan,
    required this.halal,
    required this.kosher,
    required this.discountPrice,
    required this.isOnSale,
    required this.averageRating,
    required this.reviews,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["_id"],
      name: json["name"],
      category: ProductCategory.fromJson(json["category"]),
      retailer: Store.fromJson(json["retailer"]),
      price: (json["price"] as num).toDouble(),
      stockQuantity: json["stockQuantity"],
      imageUrl: json["imageUrl"],
      storeLogo: json["storeLogo"],
      description: json["description"],
      availability: json["availability"],
      weight: json["weight"],
      brand: json["brand"],
      expiryDate: DateTime.parse(json["expiryDate"]),
      ingredients: List<String>.from(json["ingredients"]),
      allergens: List<String>.from(json["allergens"]),
      packaging: json["packaging"],
      organic: json["organic"],
      vegan: json["vegan"],
      halal: json["halal"],
      kosher: json["kosher"],
      discountPrice: (json["discountPrice"] as num).toDouble(),
      isOnSale: json["isOnSale"],
      averageRating: (json["averageRating"] as num).toDouble(),
      reviews: List<dynamic>.from(json["reviews"]),
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }
}

class ProductCategory {
  final String id;
  final String name;

  ProductCategory({required this.id, required this.name});

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json["_id"],
      name: json["name"],
    );
  }
}

class Store {
  final String id;
  final String storeName;

  Store({required this.id, required this.storeName});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json["_id"],
      storeName: json["storeName"],
    );
  }
}

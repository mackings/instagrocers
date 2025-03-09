class Retailer {
  final String id;
  final String storeName;
  final String logo;

  Retailer({
    required this.id,
    required this.storeName,
    required this.logo,
  });

  factory Retailer.fromJson(Map<String, dynamic> json) {
    return Retailer(
      id: json['_id'],
      storeName: json['storeName'],
      logo: json['logo'],
    );
  }
}

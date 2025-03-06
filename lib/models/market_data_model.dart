class MarketDataModel {
  final String commodity;
  final double price;
  final String unit;
  final String currency;

  MarketDataModel({
    required this.commodity,
    required this.price,
    required this.unit,
    required this.currency,
  });

  factory MarketDataModel.fromJson(Map<String, dynamic> json) {
    return MarketDataModel(
      commodity: json['commodity'] != null && json['commodity'].isNotEmpty
          ? json['commodity']
          : "N/A", // Fix UNKNOWN issue
      price: json['price']?.toDouble() ?? 0.0,
      unit: json['unit'] != null && json['unit'].isNotEmpty
          ? json['unit']
          : "Unknown", // Handle missing unit
      currency: json['currency'] ?? "INR",
    );
  }
}

import 'package:flutter/material.dart';
import '../models/market_data_model.dart';
import '../services/api_service.dart';

class MarketProvider with ChangeNotifier {
  List<MarketDataModel> marketData = [];
  bool isLoading = true;
  String errorMessage = '';

  Future<void> fetchMarketData(String commodityName) async {
    try {
      isLoading = true;
      notifyListeners();

      marketData = await ApiService.fetchMarketPrices(commodityName);
      errorMessage = '';
    } catch (e) {
      errorMessage = "Failed to fetch market data";
      print("Error fetching market data: $e");
    }

    isLoading = false;
    notifyListeners();
  }

}

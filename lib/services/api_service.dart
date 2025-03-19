import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/market_data_model.dart';

class ApiService {
  // ✅ Define API URLs
  static const String cropApiUrl = "https://aicroprecommendation.onrender.com"; // Crop API
  static const String yieldApiUrl = "https://flask-yeild-prediction.onrender.com"; // Yield API
  static const String marketApiUrl = "https://api.api-ninjas.com/v1/commodityprice";
  static const String pestApiUrl = "https://pest-alert-api.onrender.com/pest-alerts";
  static const String apiKey = "uVj67PqLcbgwLmXESdATqA==cFBSkIAFAcFheUU8"; // API Key

  // ✅ Fetch AI-Based Crop Suggestion
  static Future<String> fetchCropSuggestion(String soilType, double temperature, double rainfall) async {
    try {
      final response = await http.post(
        Uri.parse('$cropApiUrl/crop-suggestion'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "soilType": soilType,
          "temperature": temperature,
          "rainfall": rainfall,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['suggested_crop'] ?? "No crop recommendation found";
      } else {
        throw Exception("Failed to fetch recommendation: ${response.body}");
      }
    } catch (e) {
      return "Error fetching recommendation: $e";
    }
  }

  static Future<Map<String, List<String>>> fetchDropdownOptions() async {
    try {
      final response = await http.get(Uri.parse("$yieldApiUrl/get-options"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "crops": List<String>.from(data["crops"]),
          "states": List<String>.from(data["states"]),
          "seasons": List<String>.from(data["seasons"]),
        };
      } else {
        throw Exception("Failed to fetch dropdown options: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error fetching dropdown options: $e");
    }
  }

  // ✅ Fetch AI-Based Yield Prediction
  static Future<String> fetchYieldPrediction(
      String crop, String state, String season, double area, double rainfall, double fertilizer, double pesticide) async {
    try {
      final response = await http.post(
        Uri.parse('$yieldApiUrl/yield-prediction'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "crop": crop,
          "state": state,
          "season": season,
          "area": area,
          "rainfall": rainfall,
          "fertilizer": fertilizer,
          "pesticide": pesticide
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['predicted_yield']?.toString() ?? "No prediction available";
      } else {
        throw Exception("Failed to fetch yield prediction: ${response.body}");
      }
    } catch (e) {
      return "Error fetching yield prediction: $e";
    }
  }

  // ✅ Fetch Real-Time Market Prices
  static Future<List<MarketDataModel>> fetchMarketPrices(String commodityName) async {
    try {
      final response = await http.get(
        Uri.parse('$marketApiUrl?name=$commodityName'),
        headers: {'X-Api-Key': apiKey},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // ✅ Handle API returning a premium-only error
        if (data is Map<String, dynamic> && data.containsKey("error")) {
          print("⚠️ Premium Only Commodity: ${data["error"]}");
          return [];
        }

        if (data is Map<String, dynamic>) {
          return [MarketDataModel.fromJson(data)];
        }

        if (data is List) {
          return data.map((item) => MarketDataModel.fromJson(item)).toList();
        }

        throw Exception("Unexpected API response format");
      } else {
        throw Exception("Failed to fetch market prices: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error fetching market prices: $e");
    }
  }

  // ✅ Fetch Pest Alerts
  static Future<List<dynamic>> fetchPestAlerts({String? location}) async {
    try {
      String url = pestApiUrl;
      if (location != null) {
        url += "?location=$location";
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // ✅ If API returns a message instead of a list, handle it
        if (data is Map<String, dynamic> && data.containsKey("message")) {
          return [];
        }

        return data;
      } else {
        throw Exception("Failed to fetch pest alerts: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error fetching pest alerts: $e");
    }
  }
}

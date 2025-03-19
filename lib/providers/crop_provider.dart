import 'package:flutter/material.dart';
import '../models/crop_model.dart';
import '../services/api_service.dart';

class CropProvider with ChangeNotifier {
  CropModel? cropSuggestion;

  Future<void> fetchCropSuggestion(String soilType, double temperature, double rainfall) async {
    try {
      String suggestedCrop = await ApiService.fetchCropSuggestion(soilType, temperature, rainfall);
      cropSuggestion = CropModel(
        cropName: suggestedCrop,
        soilType: soilType,
        temperature: temperature,
        rainfall: rainfall,
      );
      notifyListeners();
    } catch (e) {
      print("Error fetching crop suggestion: $e");
    }
  }
}

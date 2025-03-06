import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class WeatherService {
  static const String apiKey = "bd5e378503939ddaee76f12ad7a97608"; // 🔹 Replace with your API key
  static const String apiUrl = "https://api.openweathermap.org/data/2.5/weather";

  // ✅ Get User's Current Location
  static Future<String> getCurrentCity() async {
    try {
      // ✅ Request Permission & Get Position
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          throw Exception("Location permissions are permanently denied.");
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // ✅ Reverse Geocode to Get City Name
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String city = placemarks.first.locality ?? "Unknown";
      return city;
    } catch (e) {
      return "Unknown";
    }
  }

  // ✅ Fetch Weather for Given City
  static Future<Map<String, dynamic>> fetchWeather(String city) async {
    try {
      final response = await http.get(
        Uri.parse("$apiUrl?q=$city&appid=$apiKey&units=metric"),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to fetch weather data");
      }
    } catch (e) {
      throw Exception("Error fetching weather: $e");
    }
  }
}

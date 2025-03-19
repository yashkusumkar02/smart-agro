import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/api_service.dart';

class CropSuggestionScreen extends StatefulWidget {
  @override
  _CropSuggestionScreenState createState() => _CropSuggestionScreenState();
}

class _CropSuggestionScreenState extends State<CropSuggestionScreen> {
  final TextEditingController temperatureController = TextEditingController();
  final TextEditingController rainfallController = TextEditingController();
  String? selectedSoilType;
  String suggestedCrop = '';
  bool isLoading = false;

  void getCropSuggestion() async {
    if (selectedSoilType == null || temperatureController.text.isEmpty || rainfallController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("⚠ Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String crop = await ApiService.fetchCropSuggestion(
        selectedSoilType!,
        double.parse(temperatureController.text),
        double.parse(rainfallController.text),
      );

      setState(() {
        suggestedCrop = crop;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        suggestedCrop = "Error fetching recommendation";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🌱 AI Crop Suggestion'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 🌍 Soil Type Dropdown
            _buildDropdown(),

            SizedBox(height: 10),

            // 🌡 Temperature Input
            _buildTextField(temperatureController, "Temperature (°C)", FontAwesomeIcons.temperatureHigh),

            SizedBox(height: 10),

            // 💦 Rainfall Input
            _buildTextField(rainfallController, "Rainfall (mm)", FontAwesomeIcons.cloudRain),

            SizedBox(height: 20),

            // 🌱 Get Recommendation Button
            ElevatedButton.icon(
              onPressed: getCropSuggestion,
              icon: Icon(FontAwesomeIcons.search, color: Colors.white),
              label: Text('Get Crop Suggestion'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),

            SizedBox(height: 20),

            // 📊 Display Suggested Crop
            _buildCropCard(),
          ],
        ),
      ),
    );
  }

  // 🌍 Soil Type Dropdown
  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButton<String>(
        hint: Text('Select Soil Type'),
        value: selectedSoilType,
        isExpanded: true,
        underline: SizedBox(),
        items: ['Loamy', 'Sandy', 'Clay', 'Silt', 'Peaty', 'Saline'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(fontSize: 16)),
          );
        }).toList(),
        onChanged: (newValue) => setState(() => selectedSoilType = newValue),
      ),
    );
  }

  // 🌡 Temperature & Rainfall Input Fields
  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green),
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
    );
  }

  // 📊 Crop Recommendation Card
  Widget _buildCropCard() {
    if (isLoading) {
      return CircularProgressIndicator(color: Colors.green);
    }

    if (suggestedCrop.isEmpty) {
      return Container();
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // 🖼 Crop Image (Using Web Links with Error Handling)
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              _getCropImageUrl(suggestedCrop),
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png", // ✅ Fallback image
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "🌾 Recommended Crop: $suggestedCrop",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }


  // 🌾 Fetch Crop Image from Web Links
  String _getCropImageUrl(String cropName) {
    Map<String, String> cropImages = {
      "Wheat": "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/Wheat_field.jpg/600px-Wheat_field.jpg",
      "Rice": "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Rice_fields_in_Bali.jpg/600px-Rice_fields_in_Bali.jpg",
      "Maize": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2d/Corn_field_Iowa.jpg/600px-Corn_field_Iowa.jpg",
      "Sugarcane": "https://upload.wikimedia.org/wikipedia/commons/thumb/1/11/Sugarcane_field.jpg/600px-Sugarcane_field.jpg",
      "Cotton": "https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/Cotton_field.jpg/600px-Cotton_field.jpg",
      "Soybean": "https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Soybean_field.jpg/600px-Soybean_field.jpg",
      "Pigeon Peas": "https://5.imimg.com/data5/SELLER/Default/2021/4/TP/GF/JH/128473321/tur-dal-toor-dal-arhar-dal-500x500.jpg",
      "Mustard": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Mustard_field.jpg/600px-Mustard_field.jpg",
    };

    return cropImages[cropName] ??
        "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/600px-Image_not_available.png"; // ✅ Reliable fallback image
  }
}

import 'package:flutter/material.dart';
import '../services/api_service.dart';

class YieldPredictionScreen extends StatefulWidget {
  @override
  _YieldPredictionScreenState createState() => _YieldPredictionScreenState();
}

class _YieldPredictionScreenState extends State<YieldPredictionScreen> {
  List<String> crops = [];
  List<String> states = [];
  List<String> seasons = [];
  String? selectedCrop;
  String? selectedState;
  String? selectedSeason;

  final TextEditingController areaController = TextEditingController();
  final TextEditingController rainfallController = TextEditingController();
  final TextEditingController fertilizerController = TextEditingController();
  final TextEditingController pesticideController = TextEditingController();

  String predictedYield = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDropdownOptions();
  }

  Future<void> _loadDropdownOptions() async {
    try {
      final options = await ApiService.fetchDropdownOptions();
      setState(() {
        crops = options["crops"]!;
        states = options["states"]!;
        seasons = options["seasons"]!;
      });
    } catch (e) {
      print("Error fetching dropdown options: $e");
    }
  }

  void predictYield() async {
    if (selectedCrop == null ||
        selectedState == null ||
        selectedSeason == null ||
        areaController.text.isEmpty ||
        rainfallController.text.isEmpty ||
        fertilizerController.text.isEmpty ||
        pesticideController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Please fill all required fields!")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      String yieldValue = await ApiService.fetchYieldPrediction(
        selectedCrop!,
        selectedState!,
        selectedSeason!,
        double.parse(areaController.text),
        double.parse(rainfallController.text),
        double.parse(fertilizerController.text),
        double.parse(pesticideController.text),
      );

      setState(() {
        predictedYield = yieldValue;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
        predictedYield = "Error fetching yield prediction.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yield Prediction'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📌 Crop Dropdown
            _buildDropdown("Select Crop", crops, (value) => setState(() => selectedCrop = value)),

            SizedBox(height: 10),

            // 🌍 State Dropdown
            _buildDropdown("Select State", states, (value) => setState(() => selectedState = value)),

            SizedBox(height: 10),

            // ⏳ Season Dropdown
            _buildDropdown("Select Season", seasons, (value) => setState(() => selectedSeason = value)),

            SizedBox(height: 10),

            // 🌾 Area Input
            _buildTextField(areaController, "Land Area (Hectares)", Icons.landscape),

            SizedBox(height: 10),

            // 💦 Rainfall Input
            _buildTextField(rainfallController, "Annual Rainfall (mm)", Icons.water_drop),

            SizedBox(height: 10),

            // 🌿 Fertilizer Input
            _buildTextField(fertilizerController, "Fertilizer (kg)", Icons.agriculture),

            SizedBox(height: 10),

            // 🦟 Pesticide Input
            _buildTextField(pesticideController, "Pesticide (kg)", Icons.bug_report),

            SizedBox(height: 20),

            // 🚀 Predict Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: predictYield,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Predict Yield", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),

            SizedBox(height: 20),

            // 📊 Result Section
            isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.green))
                : predictedYield.isNotEmpty
                ? Card(
              color: Colors.green.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.bar_chart, size: 40, color: Colors.green.shade700),
                    SizedBox(height: 10),
                    Text(
                      "Predicted Yield",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade900),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "$predictedYield metric tons",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),
            )
                : Container(),
          ],
        ),
      ),
    );
  }

  // 🌍 Reusable Dropdown
  Widget _buildDropdown(String hint, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      hint: Text(hint),
      value: null,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  // 🌿 Reusable Input Field
  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green),
        hintText: hint,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
    );
  }
}

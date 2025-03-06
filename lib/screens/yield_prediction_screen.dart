import 'package:flutter/material.dart';
import '../services/api_service.dart';

class YieldPredictionScreen extends StatefulWidget {
  @override
  _YieldPredictionScreenState createState() => _YieldPredictionScreenState();
}

class _YieldPredictionScreenState extends State<YieldPredictionScreen> {
  final TextEditingController cropController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  String predictedYield = '';
  bool isLoading = false;

  void predictYield() async {
    if (cropController.text.isEmpty || areaController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("⚠️ Please enter all fields!")));
      return;
    }

    setState(() => isLoading = true);

    try {
      String yieldValue = await ApiService.fetchYieldPrediction(
        cropController.text,
        double.parse(areaController.text),
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
            // 📌 Title
            Text(
              "Enter Crop Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            // 🌱 Crop Name Input
            TextField(
              controller: cropController,
              decoration: InputDecoration(
                labelText: 'Crop Name',
                prefixIcon: Icon(Icons.grass, color: Colors.green),
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 10),

            // 🌾 Land Area Input
            TextField(
              controller: areaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Land Area (Acres)',
                prefixIcon: Icon(Icons.landscape, color: Colors.green),
                border: OutlineInputBorder(),
              ),
            ),

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
                      "$predictedYield kg",
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
}

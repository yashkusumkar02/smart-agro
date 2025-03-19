import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/api_service.dart';

class PestAlertsScreen extends StatefulWidget {
  @override
  _PestAlertsScreenState createState() => _PestAlertsScreenState();
}

class _PestAlertsScreenState extends State<PestAlertsScreen> {
  final TextEditingController locationController = TextEditingController();
  List<dynamic> pestAlerts = [];
  bool isLoading = false;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchAlerts(); // Fetch all alerts initially
  }

  void fetchAlerts() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      var data = await ApiService.fetchPestAlerts(
          location: locationController.text.trim().isEmpty ? null : locationController.text);

      setState(() {
        pestAlerts = data;
        isLoading = false;
      });

      if (pestAlerts.isEmpty) {
        setState(() {
          errorMessage = "No pest alerts found for this location.";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "⚠ Failed to fetch pest alerts. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🦠 Pest & Disease Alerts'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 🌍 Location Input Field
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Enter Location (Optional)',
                prefixIcon: Icon(Icons.location_on, color: Colors.green),
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 10),

            // 🔍 Fetch Alerts Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: fetchAlerts,
                icon: Icon(FontAwesomeIcons.search, color: Colors.white),
                label: Text("Get Alerts"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SizedBox(height: 20),

            // 📊 Display Pest Alerts
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator(color: Colors.green))
                  : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red, fontSize: 16)))
                  : pestAlerts.isEmpty
                  ? Center(child: Text("No alerts found.", style: TextStyle(fontSize: 16)))
                  : ListView.builder(
                itemCount: pestAlerts.length,
                itemBuilder: (context, index) {
                  var alert = pestAlerts[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    elevation: 4,
                    child: ListTile(
                      leading: Icon(FontAwesomeIcons.bug, color: Colors.red.shade700),
                      title: Text(alert['disease'], style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("🌱 Affected Crops: ${alert['crops']}"),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

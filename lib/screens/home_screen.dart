import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/weather_service.dart';
import 'crop_suggestion_screen.dart';
import 'yield_prediction_screen.dart';
import 'market_data_screen.dart';
import 'pest_alerts_screen.dart';
import 'financial_planning_screen.dart';
import 'user_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String city = "Fetching...";
  String temperature = "--°C";
  String humidity = "--%";
  String rainfall = "--mm";
  String windSpeed = "-- m/s";
  bool isLoading = true;
  User? user;

  @override
  void initState() {
    super.initState();
    _fetchWeatherAndLocation();
    _listenForAuthChanges();
  }

  // 🔹 Listen for FirebaseAuth changes and update user dynamically
  void _listenForAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? updatedUser) {
      setState(() => user = updatedUser);
    });
  }

  void _fetchWeatherAndLocation() async {
    try {
      String userCity = await WeatherService.getCurrentCity();
      setState(() => city = userCity);

      var weatherData = await WeatherService.fetchWeather(userCity);
      setState(() {
        temperature = "${weatherData['main']['temp']}°C";
        humidity = "${weatherData['main']['humidity']}%";
        windSpeed = "${weatherData['wind']['speed']} m/s";
        rainfall = "0.0mm";
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        city = "Unknown";
        temperature = "N/A";
        humidity = "N/A";
        windSpeed = "N/A";
        rainfall = "N/A";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildFeatureGrid(context),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 🔹 Header Section with User Info & Weather
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      decoration: BoxDecoration(
        color: Colors.green.shade700,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 👤 Greeting and City with Profile Picture
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, ${user?.displayName ?? 'Farmer'}!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text("Weather in $city", style: TextStyle(fontSize: 16, color: Colors.white70)),
                ],
              ),

              // 📸 Profile Picture (Replaces Location Icon)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserProfileScreen()),
                  );
                },
                child: CircleAvatar(
                  radius: 22,
                  backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                  backgroundColor: Colors.white,
                  child: user?.photoURL == null
                      ? Icon(Icons.person, size: 24, color: Colors.green)
                      : null,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // 🌡 Weather Info Panel
          isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.white))
              : Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildWeatherInfo(FontAwesomeIcons.temperatureHigh, temperature, "Temperature"),
                _buildWeatherInfo(FontAwesomeIcons.tint, humidity, "Humidity"),
                _buildWeatherInfo(FontAwesomeIcons.cloudRain, rainfall, "Rainfall"),
                _buildWeatherInfo(FontAwesomeIcons.wind, windSpeed, "WindSpeed"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🌡 Weather Info Box
  Widget _buildWeatherInfo(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.green.shade700, size: 22),
        SizedBox(height: 5),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  // 🔹 Feature Grid (Smart Crop, Market Data, etc.)
  Widget _buildFeatureGrid(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {"title": "Smart Crop Suggestion", "icon": FontAwesomeIcons.seedling, "route": CropSuggestionScreen()},
      {"title": "Yield Prediction", "icon": FontAwesomeIcons.chartLine, "route": YieldPredictionScreen()},
      {"title": "Real-Time Market Data", "icon": FontAwesomeIcons.store, "route": MarketDataScreen()},
      {"title": "Pest/Disease Alerts", "icon": FontAwesomeIcons.bug, "route": PestAlertsScreen()},
      {"title": "Financial Planning", "icon": FontAwesomeIcons.coins, "route": FinancialPlanningScreen()},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: features.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, index) {
          return _buildFeatureCard(
            context,
            features[index]["title"],
            features[index]["icon"],
            features[index]["route"],
          );
        },
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, Widget route) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => route)),
      borderRadius: BorderRadius.circular(15),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 6,
        shadowColor: Colors.black26,
        color: Colors.white.withOpacity(0.9),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.green.shade800),
              SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green.shade900),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

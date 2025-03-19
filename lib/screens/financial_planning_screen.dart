import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FinancialPlanningScreen extends StatefulWidget {
  @override
  _FinancialPlanningScreenState createState() => _FinancialPlanningScreenState();
}

class _FinancialPlanningScreenState extends State<FinancialPlanningScreen> {
  final TextEditingController investmentController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  double expectedProfit = 0.0;
  bool isProfitCalculated = false;

  void calculateProfit() {
    double investment = double.tryParse(investmentController.text) ?? 0;
    double cost = double.tryParse(costController.text) ?? 0;

    setState(() {
      expectedProfit = investment - cost;
      isProfitCalculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📊 Financial Planning'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 💰 Investment Input
            _buildTextField(investmentController, "Total Investment (₹)", FontAwesomeIcons.wallet),

            SizedBox(height: 12),

            // 📉 Cost Input
            _buildTextField(costController, "Total Cost (₹)", FontAwesomeIcons.moneyBill),

            SizedBox(height: 20),

            // 🔍 Calculate Profit Button
            ElevatedButton.icon(
              onPressed: calculateProfit,
              icon: Icon(FontAwesomeIcons.calculator, color: Colors.white),
              label: Text('Calculate Profit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),

            SizedBox(height: 20),

            // 📊 Display Profit Result in a Stylish Card
            isProfitCalculated ? _buildProfitCard() : Container(),
          ],
        ),
      ),
    );
  }

  // 🔢 Input Field Builder
  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green[700]),
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
    );
  }

  // 📊 Profit Calculation Card
  Widget _buildProfitCard() {
    bool isProfitPositive = expectedProfit >= 0;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isProfitPositive ? Colors.green[100] : Colors.red[100],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              isProfitPositive ? FontAwesomeIcons.arrowUp : FontAwesomeIcons.arrowDown,
              color: isProfitPositive ? Colors.green : Colors.red,
              size: 40,
            ),
            SizedBox(height: 10),
            Text(
              isProfitPositive ? "💹 Expected Profit: ₹$expectedProfit" : "📉 Loss: ₹${-expectedProfit}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isProfitPositive ? Colors.green[800] : Colors.red[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

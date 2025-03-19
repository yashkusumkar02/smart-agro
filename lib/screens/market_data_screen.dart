import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/market_provider.dart';
import '../models/market_data_model.dart';

class MarketDataScreen extends StatefulWidget {
  @override
  _MarketDataScreenState createState() => _MarketDataScreenState();
}

class _MarketDataScreenState extends State<MarketDataScreen> {
  String selectedCommodity = "gold"; // Default commodity

  @override
  void initState() {
    super.initState();
    Future.microtask(() => fetchMarketData());
  }

  void fetchMarketData() {
    Provider.of<MarketProvider>(context, listen: false)
        .fetchMarketData(selectedCommodity);
  }

  @override
  Widget build(BuildContext context) {
    final marketProvider = Provider.of<MarketProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('📈 Market Prices'),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // ✅ Dropdown for Commodity Selection
            _buildDropdown(),

            SizedBox(height: 10),

            // ✅ Show Loading, Error, or Data
            if (marketProvider.isLoading)
              Center(child: CircularProgressIndicator())
            else if (marketProvider.errorMessage.isNotEmpty)
              Center(
                child: Text(
                  marketProvider.errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: marketProvider.marketData.length,
                  itemBuilder: (context, index) {
                    MarketDataModel data = marketProvider.marketData[index];
                    return _buildMarketCard(data);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ✅ Dropdown for Selecting Commodity
  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButton<String>(
        value: selectedCommodity,
        isExpanded: true,
        underline: SizedBox(),
        items: [
          'gold', 'platinum', 'lean_hogs', 'oat', 'aluminum',
          'soybean_meal', 'lumber', 'micro_gold', 'feeder_cattle',
          'rough_rice', 'palladium'
        ].map((commodity) => DropdownMenuItem(
          value: commodity,
          child: Row(
            children: [
              Icon(_getCommodityIcon(commodity), color: Colors.green),
              SizedBox(width: 10),
              Text(
                commodity.toUpperCase(),
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ))
            .toList(),
        onChanged: (newCommodity) {
          setState(() => selectedCommodity = newCommodity!);
          fetchMarketData();
        },
      ),
    );
  }

  // ✅ Market Data Card UI
  Widget _buildMarketCard(MarketDataModel? data) {
    if (data == null) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "❌ No Data Available for This Commodity",
            style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(_getCommodityIcon(data.commodity), size: 30, color: Colors.green[800]),
        title: Text(
          data.commodity.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          "💰 Price: ${data.currency} ${data.price} per ${data.unit}",
          style: TextStyle(fontSize: 16),
        ),
        trailing: Icon(Icons.trending_up, color: Colors.green[700]),
      ),
    );
}

  // ✅ Returns Correct Icons for Each Commodity
  IconData _getCommodityIcon(String commodity) {
    Map<String, IconData> icons = {
      "gold": FontAwesomeIcons.coins,
      "platinum": FontAwesomeIcons.gem,
      "lean_hogs": FontAwesomeIcons.piggyBank,
      "oat": FontAwesomeIcons.seedling,
      "aluminum": FontAwesomeIcons.industry,
      "soybean_meal": FontAwesomeIcons.bowlRice,
      "lumber": FontAwesomeIcons.tree,
      "micro_gold": FontAwesomeIcons.coins,
      "feeder_cattle": FontAwesomeIcons.cow,
      "rough_rice": FontAwesomeIcons.leaf,
      "palladium": FontAwesomeIcons.diamond,
    };

    return icons.containsKey(commodity.toLowerCase())
        ? icons[commodity.toLowerCase()]!
        : FontAwesomeIcons.box; // Default Icon for unknown commodities
  }
}

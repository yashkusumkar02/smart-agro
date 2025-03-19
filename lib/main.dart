import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'providers/crop_provider.dart';
import 'providers/market_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CropProvider()),
        ChangeNotifierProvider(create: (_) => MarketProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Agro Advisory',
        theme: ThemeData(primarySwatch: Colors.green),
        home: SplashScreen(), // ✅ Make sure this points to your correct splash screen
        routes: {
          '/home': (context) => HomeScreen(), // ✅ Ensure HomeScreen is registered
        },
      ),
    );
  }
}

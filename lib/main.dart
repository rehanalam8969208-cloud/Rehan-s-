import 'package:flutter/material.dart';
import 'money_tracker.dart';

void main() {
  runApp(const RehansApp());
}

class RehansApp extends StatelessWidget {
  const RehansApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Rehan's Dashboard",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        primaryColor: const Color(0xFF246CFD),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF246CFD),
          secondary: Color(0xFF00E676),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0E21),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("REHAN'S")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Dashboard
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF246CFD), Color(0xFF1B4BB5)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome Back,", style: TextStyle(color: Colors.white70, fontSize: 16)),
                    SizedBox(height: 8),
                    Text("Rehan", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text("Quick Actions", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              
              // Bottom Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    _buildMenuCard(context, icon: Icons.account_balance_wallet, title: "Money Tracker", color: const Color(0xFF246CFD), page: const MoneyTrackerScreen()),
                    _buildMenuCard(context, icon: Icons.track_changes, title: "Habit Tracker", color: const Color(0xFFFF9800), page: const Scaffold(body: Center(child: Text("Habits next step mein...")))),
                    _buildMenuCard(context, icon: Icons.flag, title: "My Goals", color: const Color(0xFFE91E63), page: const Scaffold(body: Center(child: Text("Goals next step mein...")))),
                    _buildMenuCard(context, icon: Icons.picture_as_pdf, title: "Reports", color: const Color(0xFF00E676), page: const Scaffold(body: Center(child: Text("PDF next step mein...")))),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {required IconData icon, required String title, required Color color, required Widget page}) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, size: 35, color: color),
            ),
            const SizedBox(height: 15),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600))
          ],
        ),
      ),
    );
  }
}

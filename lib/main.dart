import 'package:flutter/material.dart';
import 'money_tracker.dart';
import 'habit_tracker.dart';
import 'goals_tracker.dart';
import 'reports_screen.dart';

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
        colorScheme: const ColorScheme.dark(primary: Color(0xFF246CFD), secondary: Color(0xFF00E676)),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0A0E21), elevation: 0, centerTitle: true, iconTheme: IconThemeData(color: Colors.white), titleTextStyle: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
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
              //  STOCK MARKET STYLE DASHBOARD 
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF246CFD).withOpacity(0.5), width: 1.5),
                  boxShadow: [BoxShadow(color: const Color(0xFF246CFD).withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total Net Worth", style: TextStyle(color: Colors.white54, fontSize: 14)),
                            SizedBox(height: 5),
                            Text("₹ 4,850.00", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        // Profit Indicator
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.arrow_upward, color: Colors.greenAccent, size: 16),
                              SizedBox(width: 4),
                              Text("12.5%", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Candlesticks Pattern Simulation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(8, (index) {
                        bool isBullish = index % 2 != 0 || index == 7; // Green or Red
                        double bodyHeight = isBullish ? 30.0 + (index * 5) : 20.0 + (index * 3);
                        Color candleColor = isBullish ? Colors.greenAccent : Colors.redAccent;
                        return Column(
                          children: [
                            Container(width: 1.5, height: 10, color: candleColor), // Upper Wick
                            Container(width: 12, height: bodyHeight, decoration: BoxDecoration(color: candleColor, borderRadius: BorderRadius.circular(2))), // Body
                            Container(width: 1.5, height: 10, color: candleColor), // Lower Wick
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text("Quick Actions", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15,
                  children: [
                    _buildMenuCard(context, icon: Icons.account_balance_wallet, title: "Money Tracker", color: const Color(0xFF246CFD), page: const MoneyTrackerScreen()),
                    _buildMenuCard(context, icon: Icons.track_changes, title: "Habit Tracker", color: const Color(0xFFFF9800), page: const HabitTrackerScreen()),
                    _buildMenuCard(context, icon: Icons.flag, title: "My Goals", color: const Color(0xFFE91E63), page: const GoalsTrackerScreen()),
                    _buildMenuCard(context, icon: Icons.data_usage, title: "Reports & PDF", color: const Color(0xFF00E676), page: const ReportsScreen()),
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
        decoration: BoxDecoration(color: const Color(0xFF111827), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.3), width: 1.5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, size: 35, color: color)),
            const SizedBox(height: 15),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600))
          ],
        ),
      ),
    );
  }
}

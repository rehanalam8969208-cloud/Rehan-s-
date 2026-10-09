import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double totalBalance = 0.0;
  double percentage = 0.0;

  @override
  void initState() {
    super.initState();
    _loadSummaryData();
  }

  // 🔥 Database se Asli Paisa Padhne ka Logic 🔥
  _loadSummaryData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? txData = prefs.getString('transactions');
    double tempBalance = 0.0;
    double totalIncome = 0.0;

    if (txData != null) {
      List txList = json.decode(txData);
      for (var tx in txList) {
        tempBalance += tx['amount'];
        if (tx['amount'] > 0) totalIncome += tx['amount'];
      }
    }

    setState(() {
      totalBalance = tempBalance;
      // Agar income hai, toh percentage nikalega, warna 0.0 rahega
      if (totalIncome > 0) {
        percentage = (totalBalance / totalIncome) * 100;
      } else {
        percentage = 0.0;
      }
    });
  }

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
              // 🔥 DYNAMIC STOCK MARKET STYLE DASHBOARD 🔥
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Total Net Worth", style: TextStyle(color: Colors.white54, fontSize: 14)),
                            const SizedBox(height: 5),
                            // Yahan ab Asli total balance update hoga
                            Text("₹ ${totalBalance.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        // Dynamic Indicator (Profit/Loss ke hisaab se Red ya Green hoga)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: (totalBalance >= 0 ? Colors.greenAccent : Colors.redAccent).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: (totalBalance >= 0 ? Colors.greenAccent : Colors.redAccent).withOpacity(0.5)),
                          ),
                          child: Row(
                            children: [
                              Icon(totalBalance >= 0 ? Icons.arrow_upward : Icons.arrow_downward, color: totalBalance >= 0 ? Colors.greenAccent : Colors.redAccent, size: 16),
                              const SizedBox(width: 4),
                              Text("${percentage.toStringAsFixed(1)}%", style: TextStyle(color: totalBalance >= 0 ? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Candlesticks Pattern
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(8, (index) {
                        bool isBullish = index % 2 != 0 || index == 7;
                        double bodyHeight = isBullish ? 30.0 + (index * 5) : 20.0 + (index * 3);
                        Color candleColor = isBullish ? Colors.greenAccent : Colors.redAccent;
                        return Column(
                          children: [
                            Container(width: 1.5, height: 10, color: candleColor),
                            Container(width: 12, height: bodyHeight, decoration: BoxDecoration(color: candleColor, borderRadius: BorderRadius.circular(2))),
                            Container(width: 1.5, height: 10, color: candleColor),
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
      onTap: () {
        // 🔥 JAB BHI AAP DUSRE PAGE SE BACK AAOGE, YEH DASHBOARD KO REFRESH KAREGA 🔥
        Navigator.push(context, MaterialPageRoute(builder: (context) => page)).then((_) => _loadSummaryData());
      },
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

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  double totalBalance = 0;
  int totalHabits = 0;
  int completedHabits = 0;
  int totalGoals = 0;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  _loadSummary() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Load Money
    String? txData = prefs.getString('transactions');
    if (txData != null) {
      List txList = json.decode(txData);
      for (var tx in txList) totalBalance += tx['amount'];
    }

    // Load Habits
    String? habitData = prefs.getString('habits');
    if (habitData != null) {
      List hList = json.decode(habitData);
      totalHabits = hList.length;
      completedHabits = hList.where((h) => h['done'] == true).length;
    }

    // Load Goals
    String? goalData = prefs.getString('goals');
    if (goalData != null) {
      List gList = json.decode(goalData);
      totalGoals = gList.length;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Reports")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF111827), borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFF00E676).withOpacity(0.5))),
              child: Column(
                children: [
                  const Text("Life Summary", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const Divider(color: Colors.white30, height: 30),
                  _reportRow("Net Balance", "₹ $totalBalance"),
                  const SizedBox(height: 15),
                  _reportRow("Habits Status", "$completedHabits / $totalHabits Done"),
                  const SizedBox(height: 15),
                  _reportRow("Active Goals", "$totalGoals"),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E676),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              icon: const Icon(Icons.picture_as_pdf, color: Colors.black),
              label: const Text("Export as PDF", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Dashboard Data Exported! (Actual PDF table generation requires advanced plugin update next)")));
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _reportRow(String title, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        Text(val, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

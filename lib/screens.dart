import 'package:flutter/material.dart';

// --- 1. MONEY TRACKER SCREEN ---
class MoneyTrackerScreen extends StatelessWidget {
  const MoneyTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo transactions for UI
    final List<Map<String, dynamic>> tx = [
      {"title": "Tea & Snacks", "amount": -150.0, "date": "10 Oct 2026"},
      {"title": "Freelance Work", "amount": 5000.0, "date": "09 Oct 2026"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Money Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF246CFD).withOpacity(0.5)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Available Balance", style: TextStyle(color: Colors.white70, fontSize: 16)),
                  Text("₹ 4850.00", style: TextStyle(color: Colors.greenAccent, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft, 
              child: Text("Recent Transactions", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: tx.length,
                itemBuilder: (context, index) {
                  bool isIncome = tx[index]["amount"] > 0;
                  return Card(
                    color: const Color(0xFF111827),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward, color: isIncome ? Colors.greenAccent : Colors.redAccent),
                      title: Text(tx[index]["title"], style: const TextStyle(color: Colors.white)),
                      subtitle: Text(tx[index]["date"], style: const TextStyle(color: Colors.white54)),
                      trailing: Text("${isIncome ? '+' : ''}₹${tx[index]["amount"].abs()}", style: TextStyle(color: isIncome ? Colors.greenAccent : Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF246CFD),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Add Transaction form phase 3 mein aayega!")));
        },
      ),
    );
  }
}

// --- 2. HABIT TRACKER SCREEN ---
class HabitTrackerScreen extends StatelessWidget {
  const HabitTrackerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Habit Tracker")),
      body: const Center(child: Text("Habit Tracker Coming Soon...", style: TextStyle(color: Colors.white, fontSize: 18))),
    );
  }
}

// --- 3. GOALS SCREEN ---
class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Goals")),
      body: const Center(child: Text("Goals Tracker Coming Soon...", style: TextStyle(color: Colors.white, fontSize: 18))),
    );
  }
}

// --- 4. REPORTS SCREEN ---
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detailed Reports (PDF)")),
      body: const Center(child: Text("PDF Generation Coming Soon...", style: TextStyle(color: Colors.white, fontSize: 18))),
    );
  }
}

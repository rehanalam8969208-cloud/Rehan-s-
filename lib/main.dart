import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: const Text("REHAN'S"),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Color(0xFF246CFD)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportsScreen()));
            },
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Dashboard Card - Fully Clickable
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF246CFD), Color(0xFF1B4BB5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: const Color(0xFF246CFD).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Clickable Balance Section
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MoneyTrackerScreen())),
                      child: Container(
                        color: Colors.transparent, // Makes the whole area clickable
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total Balance (Tap to view history)", style: TextStyle(color: Colors.white70, fontSize: 14)),
                            SizedBox(height: 5),
                            Text("₹ 4,850.00", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: Colors.white30, thickness: 1),
                    ),
                    // Clickable Goals & Habits Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GoalsScreen())),
                          child: const Text("Active Goals: 2  ➔", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HabitTrackerScreen())),
                          child: const Text("Habits Done: 4/5  ➔", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text("Quick Actions", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              
              // Bottom Grid Buttons
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    _buildMenuCard(context, icon: Icons.account_balance_wallet, title: "Money Tracker", color: const Color(0xFF246CFD), page: const MoneyTrackerScreen()),
                    _buildMenuCard(context, icon: Icons.track_changes, title: "Habit Tracker", color: const Color(0xFFFF9800), page: const HabitTrackerScreen()),
                    _buildMenuCard(context, icon: Icons.flag, title: "My Goals", color: const Color(0xFFE91E63), page: const GoalsScreen()),
                    _buildMenuCard(context, icon: Icons.picture_as_pdf, title: "Download PDF", color: const Color(0xFF00E676), page: const ReportsScreen()),
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

// --- ALL INDIVIDUAL SCREENS ---

class MoneyTrackerScreen extends StatelessWidget {
  const MoneyTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tx = [
      {"title": "Tea & Snacks", "amount": -150.0, "date": "10 Oct 2026", "type": "Expense"},
      {"title": "Freelance Client", "amount": 5000.0, "date": "09 Oct 2026", "type": "Income"},
      {"title": "Fuel", "amount": -500.0, "date": "08 Oct 2026", "type": "Expense"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Money Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Transaction History", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: tx.length,
                itemBuilder: (context, index) {
                  bool isIncome = tx[index]["amount"] > 0;
                  return Card(
                    color: const Color(0xFF111827),
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward, color: isIncome ? Colors.greenAccent : Colors.redAccent),
                      title: Text(tx[index]["title"], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF246CFD),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add ₹", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () {},
      ),
    );
  }
}

class HabitTrackerScreen extends StatelessWidget {
  const HabitTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habits = [
      {"name": "Morning Workout", "done": true},
      {"name": "Read 10 Pages", "done": true},
      {"name": "Drink 3L Water", "done": false},
      {"name": "Coding Practice", "done": true},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Habit Tracker")),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: habits.length,
        itemBuilder: (context, index) {
          bool isDone = habits[index]["done"] as bool;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: isDone ? Colors.greenAccent.withOpacity(0.5) : Colors.white12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(habits[index]["name"] as String, style: TextStyle(color: Colors.white, fontSize: 16, decoration: isDone ? TextDecoration.lineThrough : null)),
                Icon(isDone ? Icons.check_circle : Icons.circle_outlined, color: isDone ? Colors.greenAccent : Colors.white54),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF9800),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {},
      ),
    );
  }
}

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Goals")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildGoalCard("Save for Laptop", 0.6, "₹ 60,000 / ₹ 1,00,000"),
            const SizedBox(height: 15),
            _buildGoalCard("Learn Flutter", 0.8, "80% Completed"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE91E63),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {},
      ),
    );
  }

  Widget _buildGoalCard(String title, double progress, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE91E63).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          LinearProgressIndicator(value: progress, backgroundColor: Colors.white12, color: const Color(0xFFE91E63), minHeight: 8),
          const SizedBox(height: 10),
          Text(subtitle, style: const TextStyle(color: Colors.white54)),
        ],
      ),
    );
  }
}

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Generate PDF Report")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.picture_as_pdf, size: 80, color: Color(0xFF00E676)),
            const SizedBox(height: 20),
            const Text("Your Monthly Summary is Ready", style: TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E676),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              icon: const Icon(Icons.download, color: Colors.black),
              label: const Text("Download PDF", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}

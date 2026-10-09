import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GoalsTrackerScreen extends StatefulWidget {
  const GoalsTrackerScreen({super.key});
  @override
  State<GoalsTrackerScreen> createState() => _GoalsTrackerScreenState();
}

class _GoalsTrackerScreenState extends State<GoalsTrackerScreen> {
  List<Map<String, dynamic>> goals = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('goals');
    if (data != null) setState(() => goals = List<Map<String, dynamic>>.from(json.decode(data)));
  }

  _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('goals', json.encode(goals));
  }

  _addGoal(String title, double target) {
    setState(() => goals.add({"title": title, "target": target, "current": 0.0}));
    _saveData();
  }

  _addProgress(int index, double amount) {
    setState(() => goals[index]["current"] += amount);
    _saveData();
  }

  // 🔥 Long Press Confirm Delete Logic 🔥
  _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        title: const Text("Delete Goal?", style: TextStyle(color: Colors.white)),
        content: const Text("Are you sure you want to delete this goal?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel", style: TextStyle(color: Colors.white54))),
          TextButton(
            onPressed: () { 
              setState(() => goals.removeAt(index)); 
              _saveData(); 
              Navigator.pop(ctx); 
            }, 
            child: const Text("Delete", style: TextStyle(color: Colors.redAccent))
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Goals")),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: goals.length,
        itemBuilder: (context, index) {
          double progress = goals[index]["current"] / goals[index]["target"];
          if (progress > 1.0) progress = 1.0;
          return GestureDetector(
            onLongPress: () => _confirmDelete(index), // Yahan long press lagaya gaya hai
            child: Card(
              color: const Color(0xFF111827),
              margin: const EdgeInsets.only(bottom: 15),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(goals[index]["title"], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(value: progress, backgroundColor: Colors.white12, color: const Color(0xFFE91E63), minHeight: 8),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("₹${goals[index]["current"]} / ₹${goals[index]["target"]}", style: const TextStyle(color: Colors.white54)),
                        GestureDetector(
                          onTap: () {
                            TextEditingController ctrl = TextEditingController();
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: const Color(0xFF111827),
                                title: const Text("Add Progress Amount", style: TextStyle(color: Colors.white)),
                                content: TextField(controller: ctrl, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white)),
                                actions: [TextButton(onPressed: () { _addProgress(index, double.parse(ctrl.text)); Navigator.pop(ctx); }, child: const Text("Add"))],
                              )
                            );
                          },
                          child: const Text("+ Add ₹", style: TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.bold)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE91E63),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          TextEditingController titleCtrl = TextEditingController();
          TextEditingController targetCtrl = TextEditingController();
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: const Color(0xFF111827),
              title: const Text("New Goal", style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: titleCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: "Goal Name", hintStyle: TextStyle(color: Colors.white54))),
                  TextField(controller: targetCtrl, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: "Target Amount (₹)", hintStyle: TextStyle(color: Colors.white54))),
                ],
              ),
              actions: [TextButton(onPressed: () { _addGoal(titleCtrl.text, double.parse(targetCtrl.text)); Navigator.pop(ctx); }, child: const Text("Save"))],
            )
          );
        },
      ),
    );
  }
}

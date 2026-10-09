import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HabitTrackerScreen extends StatefulWidget {
  const HabitTrackerScreen({super.key});
  @override
  State<HabitTrackerScreen> createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> {
  List<Map<String, dynamic>> habits = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('habits');
    if (data != null) setState(() => habits = List<Map<String, dynamic>>.from(json.decode(data)));
  }

  _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('habits', json.encode(habits));
  }

  _addHabit(String name) {
    setState(() => habits.add({"name": name, "done": false}));
    _saveData();
  }

  _toggleHabit(int index) {
    setState(() => habits[index]["done"] = !habits[index]["done"]);
    _saveData();
  }

  // 🔥 Long Press Confirm Delete Logic 🔥
  _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        title: const Text("Delete Habit?", style: TextStyle(color: Colors.white)),
        content: const Text("Are you sure you want to delete this habit?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel", style: TextStyle(color: Colors.white54))),
          TextButton(
            onPressed: () { 
              setState(() => habits.removeAt(index)); 
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
      appBar: AppBar(title: const Text("Habit Tracker")),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: habits.length,
        itemBuilder: (context, index) {
          bool isDone = habits[index]["done"];
          return Card(
            color: const Color(0xFF111827),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              onLongPress: () => _confirmDelete(index), // Yahan long press lagaya gaya hai
              leading: IconButton(
                icon: Icon(isDone ? Icons.check_circle : Icons.circle_outlined, color: isDone ? Colors.greenAccent : Colors.white54),
                onPressed: () => _toggleHabit(index),
              ),
              title: Text(habits[index]["name"], style: TextStyle(color: Colors.white, decoration: isDone ? TextDecoration.lineThrough : null)),
              // Delete icon trailing se hata diya gaya hai
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF9800),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          TextEditingController ctrl = TextEditingController();
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: const Color(0xFF111827),
              title: const Text("New Habit", style: TextStyle(color: Colors.white)),
              content: TextField(controller: ctrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: "E.g. Read 10 Pages", hintStyle: TextStyle(color: Colors.white54))),
              actions: [TextButton(onPressed: () { _addHabit(ctrl.text); Navigator.pop(ctx); }, child: const Text("Save"))],
            )
          );
        },
      ),
    );
  }
}

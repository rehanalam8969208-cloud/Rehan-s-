import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MoneyTrackerScreen extends StatefulWidget {
  const MoneyTrackerScreen({super.key});

  @override
  State<MoneyTrackerScreen> createState() => _MoneyTrackerScreenState();
}

class _MoneyTrackerScreenState extends State<MoneyTrackerScreen> {
  List<Map<String, dynamic>> transactions = [];
  double totalBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData(); // App khulte hi save kiya hua data load karega
  }

  // Database se data nikalna
  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? txString = prefs.getString('transactions');
    if (txString != null) {
      setState(() {
        transactions = List<Map<String, dynamic>>.from(json.decode(txString));
        _calculateTotal();
      });
    }
  }

  // Database mein data hamesha ke liye save karna
  _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('transactions', json.encode(transactions));
    _calculateTotal();
  }

  _calculateTotal() {
    totalBalance = 0.0;
    for (var tx in transactions) {
      totalBalance += tx['amount'];
    }
    setState(() {});
  }

  // Add / Edit / Delete karne ka Box
  _showTransactionDialog({int? index}) {
    TextEditingController titleController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    bool isExpense = false;

    if (index != null) {
      titleController.text = transactions[index]['title'];
      amountController.text = transactions[index]['amount'].abs().toString();
      isExpense = transactions[index]['amount'] < 0;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF111827),
              title: Text(index == null ? "Add Entry" : "Edit Entry", style: const TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: "Description (Eg. Chai, Salary)", labelStyle: TextStyle(color: Colors.white54)),
                  ),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: "Amount (₹)", labelStyle: TextStyle(color: Colors.white54)),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ChoiceChip(
                        label: const Text("Income"),
                        selected: !isExpense,
                        onSelected: (val) => setDialogState(() => isExpense = false),
                        selectedColor: Colors.green,
                        backgroundColor: Colors.grey[900],
                      ),
                      ChoiceChip(
                        label: const Text("Expense"),
                        selected: isExpense,
                        onSelected: (val) => setDialogState(() => isExpense = true),
                        selectedColor: Colors.red,
                        backgroundColor: Colors.grey[900],
                      ),
                    ],
                  )
                ],
              ),
              actions: [
                if (index != null)
                  TextButton(
                    onPressed: () {
                      transactions.removeAt(index);
                      _saveData();
                      Navigator.pop(context);
                    },
                    child: const Text("Delete", style: TextStyle(color: Colors.red)),
                  ),
                TextButton(
                  onPressed: () {
                    double amt = double.tryParse(amountController.text) ?? 0.0;
                    if (isExpense) amt = -amt;
                    if (index == null) {
                      transactions.add({"title": titleController.text, "amount": amt});
                    } else {
                      transactions[index] = {"title": titleController.text, "amount": amt};
                    }
                    _saveData();
                    Navigator.pop(context);
                  },
                  child: const Text("Save", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Money Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF246CFD).withOpacity(0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Current Balance", style: TextStyle(color: Colors.white70, fontSize: 16)),
                  Text("₹ ${totalBalance.toStringAsFixed(2)}", style: TextStyle(color: totalBalance >= 0 ? Colors.greenAccent : Colors.redAccent, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text("History (Tap to Edit/Delete)", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: transactions.isEmpty
                  ? const Center(child: Text("No data yet. Add your first entry!", style: TextStyle(color: Colors.white54)))
                  : ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        bool isIncome = transactions[index]["amount"] > 0;
                        return Card(
                          color: const Color(0xFF111827),
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            onTap: () => _showTransactionDialog(index: index), // Tap to Edit/Delete
                            leading: Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward, color: isIncome ? Colors.greenAccent : Colors.redAccent),
                            title: Text(transactions[index]["title"], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            trailing: Text("${isIncome ? '+' : ''}₹${transactions[index]["amount"].abs()}", style: TextStyle(color: isIncome ? Colors.greenAccent : Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
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
        onPressed: () => _showTransactionDialog(),
      ),
    );
  }
}

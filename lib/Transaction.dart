import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  String? _selectedYear;
  String? _selectedMonth;
  final List<Map<String, dynamic>> _transactions = [];

  @override
  void initState() {
    super.initState();
    final currentYear = DateTime.now().year;
    _selectedYear = currentYear.toString();
    _selectedMonth = DateFormat.MMMM().format(DateTime.now());
    _generateRandomTransactions();
  }

  void _generateRandomTransactions() {
    final random = Random();
    final List<String> foodItems = ['Burger', 'Pizza', 'Pasta', 'Salad', 'Sushi', 'Taco', 'Steak', 'Sandwich', 'Soup', 'Curry'];

    for (int year = 2023; year <= 2024; year++) {
      for (int month = 1; month <= 12; month++) {
        for (int i = 0; i < 10; i++) {
          final day = random.nextInt(28) + 1; // Ensure valid day in month
          final hour = random.nextInt(24);
          final minute = random.nextInt(60);
          final date = DateTime(year, month, day, hour, minute);
          final food = foodItems[random.nextInt(foodItems.length)];
          final cost = random.nextDouble() * 20 + 5; // Random cost between $5 and $25

          _transactions.add({'date': date, 'food': food, 'cost': cost});
        }
      }
    }
  }

  List<String> get _years {
    final currentYear = DateTime.now().year;
    return List.generate(4, (index) => (currentYear - index).toString());
  }

  List<String> get _months {
    return List.generate(12, (index) => DateFormat.MMMM().format(DateTime(0, index + 1)));
  }

  List<Map<String, dynamic>> get _filteredTransactions {
    final monthIndex = _months.indexOf(_selectedMonth!) + 1;
    return _transactions.where((transaction) {
      return transaction['date'].year.toString() == _selectedYear &&
          transaction['date'].month == monthIndex;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedYear,
                    decoration: const InputDecoration(labelText: 'Year'),
                    items: _years.map((year) {
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedYear = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedMonth,
                    decoration: const InputDecoration(labelText: 'Month'),
                    items: _months.map((month) {
                      return DropdownMenuItem(
                        value: month,
                        child: Text(month),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMonth = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  border: TableBorder.all(),
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(3),
                    3: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Time', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Food', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Cost', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    ..._filteredTransactions.map((transaction) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(DateFormat.yMd().format(transaction['date'])),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(DateFormat.Hm().format(transaction['date'])),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(transaction['food']),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('\$${transaction['cost'].toStringAsFixed(2)}'),
                          ),
                        ],
                      );
                    }).toList(),
                    if (_filteredTransactions.isEmpty)
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('No transactions available for the selected period.', textAlign: TextAlign.center),
                          ),
                          const SizedBox(),
                          const SizedBox(),
                          const SizedBox(),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TopupAmountPage extends StatefulWidget {
  final void Function(double amount) onLoadMoney;

  const TopupAmountPage({Key? key, required this.onLoadMoney}) : super(key: key);

  @override
  _TopupAmountPageState createState() => _TopupAmountPageState();
}

class _TopupAmountPageState extends State<TopupAmountPage> {
  final TextEditingController _amountController = TextEditingController();

  void _loadMoney() {
    double amount = double.tryParse(_amountController.text) ?? 0;
    widget.onLoadMoney(amount);
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close the TopupAmountPage
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Topup',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0095FF),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'RS:',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _loadMoney,
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff0095FF),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Load Money',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

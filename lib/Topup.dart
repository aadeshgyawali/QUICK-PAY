import 'package:flutter/material.dart';
import 'TopupAmountPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopupPage extends StatefulWidget {
  final void Function(double amount) onTopUp;

  const TopupPage({Key? key, required this.onTopUp}) : super(key: key);

  @override
  _TopupPageState createState() => _TopupPageState();
}

class _TopupPageState extends State<TopupPage> {
  String? _selectedPaymentMethod;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  double _currentNrp = 0.0;

  @override
  void initState() {
    super.initState();
    _loadNrp();
  }

  void _loadNrp() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentNrp = prefs.getDouble('nrp') ?? 0.0;
    });
  }

  void _onPaymentMethodSelected(String method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  void _submitTopUp() async {
    final id = _idController.text.trim();
    final pin = _pinController.text.trim();

    if (_selectedPaymentMethod != null && id.isNotEmpty && pin.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TopupAmountPage(
            onLoadMoney: (amount) async {
              // Validate the amount
              if (amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid amount.')),
                );
                return;
              }

              // Add the top-up amount to the current nrp
              setState(() {
                _currentNrp += amount;
              });

              final prefs = await SharedPreferences.getInstance();
              await prefs.setDouble('nrp', _currentNrp);

              // Notify the home page (if needed)
              widget.onTopUp(amount);

              // Clear the fields after successful navigation
              _idController.clear();
              _pinController.clear();

              Navigator.pop(context); // Close the TopupAmountPage
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pop(context); // Close the TopupPage and go back to HomePage
              });
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method and fill in all fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'TOPUP',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0095FF),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Select Payment Method',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              PaymentMethodButton(
                onPressed: () => _onPaymentMethodSelected('Khalti'),
                icon: Icons.payment,
                label: 'Khalti',
              ),
              const SizedBox(height: 10),
              PaymentMethodButton(
                onPressed: () => _onPaymentMethodSelected('eSewa'),
                icon: Icons.account_balance_wallet,
                label: 'eSewa',
              ),
              const SizedBox(height: 10),
              PaymentMethodButton(
                onPressed: () => _onPaymentMethodSelected('Mobile Banking'),
                icon: Icons.phone_android,
                label: 'Mobile Banking',
              ),
              const SizedBox(height: 30),
              Visibility(
                visible: _selectedPaymentMethod != null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Paying with $_selectedPaymentMethod',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _idController,
                      decoration: InputDecoration(
                        labelText: 'ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        prefixIcon: const Icon(Icons.account_circle),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _pinController,
                      decoration: InputDecoration(
                        labelText: 'PIN',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _submitTopUp,
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xff0095FF),
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentMethodButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const PaymentMethodButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 28),
      label: Text(
        label,
        style: const TextStyle(fontSize: 18),
      ),
      style: ElevatedButton.styleFrom(
        primary: const Color(0xff0095FF),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}

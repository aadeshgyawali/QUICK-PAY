import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'Profile.dart';
import 'Topup.dart';
import 'Transaction.dart';
import 'Setting.dart';

class HomePage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String registrationNo;
  double nrp;

  HomePage({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.registrationNo,
    required this.nrp,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _updateNrp(double amount) {
    setState(() {
      widget.nrp += amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeContent(
        firstName: widget.firstName,
        lastName: widget.lastName,
        registrationNo: widget.registrationNo,
        nrp: widget.nrp,
      ),
      const TransactionPage(),
      TopupPage(onTopUp: _updateNrp),
      ProfilePage(),
      const SettingsPage(),
    ];

    final List<String> titles = [
      'Home Page',
      'Transaction History',
      'Top Up',
      'Profile',
      'Settings',
    ];

    void _onItemTapped(int index) {
      setState(() {
        _currentIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
        backgroundColor: const Color(0xff0095FF),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Transactions'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Top Up'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String registrationNo;
  final double nrp; // Changed to double

  const HomeContent({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.registrationNo,
    required this.nrp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nrpValue = nrp; // Directly use the double value

    // Sample data for the chart
    final List<ChartData> incomeData = [
      ChartData(x: 1, y: nrpValue * 0.8), // Example calculation
      ChartData(x: 2, y: nrpValue * 0.9),
      ChartData(x: 3, y: nrpValue * 0.7),
    ];

    final List<ChartData> expenseData = [
      ChartData(x: 1, y: nrpValue * 0.4),
      ChartData(x: 2, y: nrpValue * 0.3),
      ChartData(x: 3, y: nrpValue * 0.5),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Welcome, $firstName $lastName',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 30),
          Text('Registration No: $registrationNo',
              style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          Text('NRP: $nrpValue', style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 30),
          // Chart added here
          Container(
            height: 300, // Adjust height as needed
            child: SfCartesianChart(
              series: <CartesianSeries<ChartData, num>>[
                LineSeries<ChartData, num>(
                  dataSource: incomeData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  name: 'Income',
                ),
                ColumnSeries<ChartData, num>(
                  dataSource: expenseData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  name: 'Expense',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Data class for the chart
class ChartData {
  final num x;
  final num y;

  ChartData({required this.x, required this.y});
}


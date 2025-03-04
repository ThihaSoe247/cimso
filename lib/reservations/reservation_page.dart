import 'package:flutter/material.dart';

import 'reservation_details.dart';

class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  String _selectedCategory = 'All';

  // Sample data for reservations
  List<Map<String, dynamic>> _allReservations = [
    {
      'type': 'Hotel',
      'date': '2025-03-15',
      'details': 'Deluxe Room at XYZ Hotel',
    },
    {
      'type': 'Golf',
      'date': '2025-03-16',
      'details': '18-hole session at ABC Golf Course',
    },
    {
      'type': 'Spa',
      'date': '2025-03-17',
      'details': 'Full Body Massage at Wellness Center',
    },
    {
      'type': 'Restaurant',
      'date': '2025-03-18',
      'details': 'Dinner Reservation at Gourmet Bistro',
    },
  ];

  List<Map<String, dynamic>> _getFilteredReservations() {
    if (_selectedCategory == 'All') {
      return _allReservations;
    } else {
      return _allReservations
          .where((reservation) =>
      reservation['type'] == _selectedCategory)
          .toList();
    }
  }

  void _viewReservationDetails(Map<String, dynamic> reservation) {
    // Navigate to the detailed reservation page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationDetailPage(reservation: reservation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reservations")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _categoryButton('All'),
                  _categoryButton('Hotel'),
                  _categoryButton('Golf'),
                  _categoryButton('Spa'),
                  _categoryButton('Restaurant'),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _getFilteredReservations().length,
              itemBuilder: (context, index) {
                var reservation = _getFilteredReservations()[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 5.0,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12.0),
                    title: Text(
                      reservation['type'],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${reservation['date']}'),
                        SizedBox(height: 4.0),
                        Text(
                          'Details: ${reservation['details']}',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () => _viewReservationDetails(reservation),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryButton(String category) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: _selectedCategory == category
              ? Colors.greenAccent
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          category,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _selectedCategory == category ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

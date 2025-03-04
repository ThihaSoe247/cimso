import 'package:flutter/material.dart';

class ReservationDetailPage extends StatelessWidget {
  final Map<String, dynamic> reservation;

  ReservationDetailPage({required this.reservation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50], // Soft green background
      appBar: AppBar(
        title: Text('${reservation['type']} Details'),
        backgroundColor: Colors.green, // Green app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reservation Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  'assets/images/${reservation['type'].toLowerCase()}.jpeg', // Change the path as needed
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),

              // Reservation Type Card
              _buildInfoCard('Reservation Type:', reservation['type'], Colors.green[100], Colors.green[800]),

              SizedBox(height: 10),

              // Reservation Date Card
              _buildInfoCard('Date:', reservation['date'], Colors.green[50], Colors.green[700]),

              SizedBox(height: 20),

              // Reservation Details Card
              _buildDetailsCard('Details:', reservation['details'], Colors.green[50], Colors.green[600]),

              SizedBox(height: 20),

              // Price Card
              _buildInfoCard('Price:', '\$${reservation['price']}', Colors.green[100], Colors.green[800]),

              SizedBox(height: 20),

              // Additional Information Card
              _buildDetailsCard('Additional Information:',
                  'Location: XYZ Location\nContact: 123-456-7890\nBooking Reference: ABC123', Colors.green[100], Colors.green[600]),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build a card with title and content
  Widget _buildInfoCard(String title, String content, Color? cardColor, Color? textColor) {
    return Container(
      width: double.infinity,
      child: Card(
        color: cardColor, // Card background color
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                content,
                style: TextStyle(
                  fontSize: 18,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build a card with details content
  Widget _buildDetailsCard(String title, String content, Color? cardColor, Color? textColor) {
    return Container(
      width: double.infinity,
      child: Card(
        color: cardColor, // Card background color
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                content,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

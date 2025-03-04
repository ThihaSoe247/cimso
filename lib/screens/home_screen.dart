import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../functions/profile_edit.dart';
import '../reservations/reservation_page.dart';
import '../functions/statement_page.dart';
import '../functions/vouchers_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Color(0xFF388E3C),
        elevation: 4.0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('members')
            .doc(userId)
            .snapshots(), // Listen for real-time updates
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("User not found"));
          }

          var userDoc = snapshot.data!;
          String fullName = userDoc['fullName'] ?? 'Unknown';
          String email = userDoc['email'] ?? 'No Email';
          String clientID = userDoc['clientID'] ?? 'N/A';
          String memberID = "KUL001"; // You can update this based on your Firestore logic

          return ListView(
            children: [
              // Member Info Card
              Container(
                margin: EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfilePage()),
                    );
                  },
                  child: Card(
                    elevation: 5.0,
                    color: Color(0xFFE8F5E9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding:  EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/cimsocircle.jpeg",
                            width: 130,
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fullName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF388E3C),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Member ID: $memberID",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "Client ID: $clientID",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Buttons in a Column
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Material(
                  elevation: 5.0,
                  shadowColor: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  child: Column(
                    children: [
                      _buildButton("Reservations", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReservationPage()),
                        );
                      }),
                      _buildButton("Statements", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StatementPage()),
                        );
                      }),
                      _buildButton("Vouchers", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VoucherPage()),
                        );
                      }),
                      _buildButton("History", () {
                        // Add navigation if needed
                      }),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper function for vertical buttons
  Widget _buildButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, // Full width
        height: 180,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.greenAccent, // Light green background
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
        ),
      ),
    );
  }
}

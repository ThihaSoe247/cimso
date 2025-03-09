import 'package:cimso_heckathon/functions/drawer.dart';
import 'package:cimso_heckathon/vouchers/voucher_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../functions/membercard.dart';
import '../functions/profile_edit.dart';
import '../hotel/hotel_homepage.dart';
import '../reservations/reservation_page.dart';
import '../statements/statement_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.lightGreen,
      drawer: MyDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.notifications))
        ],
        title: Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4.0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('members')
            .doc(userId)
            .snapshots(),
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
          String memberID = userDoc['memberID'] ?? 'N/A';

          return Container(
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfilePage()),
                      );
                    },
                    child: MembershipCard(
                      name: fullName,
                      memberID: memberID,
                      clientID: clientID,
                    ),
                  ),
                ),
            
                // Row of Buttons
                Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildButton("Hotel Booking", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HotelListPage()),
                          );
                        }),
                        _buildButton("Reservations", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BookedItemsScreen()),
                          );
                        }),
                      ],
                    ),
            
                ),
                Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildButton("Statements", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => StatementPage()),
                          );
                        }),
                        _buildButton("Vouchers", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => VoucherCardsPage()),
                          );
                        }),
                      ],
                    ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper function for buttons
  Widget _buildButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180, // Adjust width to match button size
        margin: EdgeInsets.symmetric(vertical: 5),

        decoration: BoxDecoration(
          // Applying a gradient color
          gradient: LinearGradient(
            colors: [Colors.white54, Colors.greenAccent], // Dark gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20, // Adjust font size
            ),
          ),
        ),
      ),
    );
  }
}

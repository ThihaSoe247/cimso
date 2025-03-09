import 'package:flutter/material.dart';

class MembershipCard extends StatelessWidget {
  final String name;
  final String clientID;
  final String memberID;

  MembershipCard({
    required this.name,
    required this.clientID,
    required this.memberID,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          elevation: 15.0, // Increased elevation for more shadow effect
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            height: 200,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              // Applying a green gradient color
              gradient: LinearGradient(
                colors: [Color(0xFF81C784), Colors.black], // Green gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Membership title with updated font size
                Text(
                  "Cimso Membership",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.white,
                    fontSize: 24, // Adjust font size
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10), // Add some spacing between the title and the content
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Display dynamic name with adjusted font size
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0, // Adjust font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Points value with adjusted font size
                    Text(
                      memberID,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0, // Adjust font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10), // Add some spacing between rows
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Membership type label with adjusted font size
                    Text(
                      'Platinum',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0, // Adjust font size
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Points label with adjusted font size
                    Text(
                      '5000 Points',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0, // Adjust font size
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "09/28",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0, // Adjust font size
                        fontWeight: FontWeight.bold, // Adjust font size
                      ),
                    ),
                    Image.asset("assets/images/cimsocircle.jpeg", width: 60, fit: BoxFit.cover)
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10), // Space before Category text
        Text(
          "Category",
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

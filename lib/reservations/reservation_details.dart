import 'package:cimso_heckathon/reservations/reservation_page.dart';
import 'package:cimso_heckathon/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
class BookingDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> booking;

  BookingDetailsScreen({required this.booking});

  @override
  _BookingDetailsScreenState createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  Future<void> moveToCompleted(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Access the user's reservation subcollection and find the booking by matching its details
        QuerySnapshot reservationsSnapshot = await FirebaseFirestore.instance
            .collection('members')
            .doc(user.uid)
            .collection('reservations')
            .get();

        // Find the matching booking based on data
        for (var doc in reservationsSnapshot.docs) {
          var bookingData = doc.data() as Map<String, dynamic>;

          // Compare the booking data
          if (bookingData['hotelName'] == widget.booking['hotelName'] &&
              bookingData['checkInDate'].toDate().isAtSameMomentAs(widget.booking['checkInDate'].toDate()) &&
              bookingData['checkOutDate'].toDate().isAtSameMomentAs(widget.booking['checkOutDate'].toDate()) &&
              bookingData['guests'] == widget.booking['guests'] &&
              bookingData['specialRequests'] == widget.booking['specialRequests']) {

            await doc.reference.update({
              'completed': true, // Mark as completed in the original booking
            });

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()), // Replace with your hotel list screen
                  (Route<dynamic> route) => false, // Removes all previous routes
            );

            // Show a confirmation message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Booking moved to completed successfully')),
            );


            setState(() {
              // Refresh UI by updating the state
              widget.booking['completed'] = true;
            });


          }
        }
      } catch (e) {
        // Handle error during moving the booking
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error moving booking')),
        // );
      }
    }
  }

  // Function to delete the booking from the "reservations" collection
  Future<void> deleteBooking(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Access the user's reservation subcollection and find the booking by matching its details
        QuerySnapshot reservationsSnapshot = await FirebaseFirestore.instance
            .collection('members')
            .doc(user.uid)
            .collection('reservations')
            .get();

        // Find the matching booking based on data
        for (var doc in reservationsSnapshot.docs) {
          var bookingData = doc.data() as Map<String, dynamic>;

          // Compare the booking data
          if (bookingData['hotelName'] == widget.booking['hotelName'] &&
              bookingData['checkInDate'].toDate().isAtSameMomentAs(widget.booking['checkInDate'].toDate()) &&
              bookingData['checkOutDate'].toDate().isAtSameMomentAs(widget.booking['checkOutDate'].toDate()) &&
              bookingData['guests'] == widget.booking['guests'] &&
              bookingData['specialRequests'] == widget.booking['specialRequests']) {

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()), // Replace with your hotel list screen
                  (Route<dynamic> route) => false, // Removes all previous routes
            );
            await doc.reference.delete();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Booking deleted successfully')),
            );





          }
        }
      } catch (e) {
        // Handle error during deleting the booking
        // print("Error deleting booking: $e");
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error deleting booking')),
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format the dates to show only the date part (no time)
    String checkInDate = DateFormat('dd-MM-yyyy').format(widget.booking['checkInDate'].toDate());
    String checkOutDate = DateFormat('dd-MM-yyyy').format(widget.booking['checkOutDate'].toDate());

    // Generate asset path based on hotel name
    String hotelImagePath = 'assets/images/${widget.booking['hotelName'].split(' ')[0].toLowerCase()}.jpeg';

    return Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: AppBar(
        title: Text('Booking Details'),
        backgroundColor: Colors.white, // Color for AppBar
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Image (using local assets)
                  Center(
                    child: Image.asset(
                      hotelImagePath,
                      height: 200.0,
                      width: 400.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: 20.0),

                  // Title and details as paper receipt
                  Text(
                    widget.booking['hotelName'],
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    height: 2.0,
                    color: Colors.orange,
                  ),
                  SizedBox(height: 10.0),

                  // Display the check-in and check-out dates
                  Text(
                    'Check-in: $checkInDate',
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Check-out: $checkOutDate',
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  SizedBox(height: 16.0),

                  // Display the price in a formal receipt style with color
                  Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TOTAL PRICE:',
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(
                          '\$${widget.booking['totalPrice']}',
                          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),

                  // Guest and special request information
                  Text(
                    'Guests: ${widget.booking['guests']}',
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Special Requests: ${widget.booking['specialRequests'] ?? 'None'}',
                    style: TextStyle(fontSize: 18.0, color: Colors.pink),
                  ),
                  SizedBox(height: 20.0),

                  // Divider for the receipt look
                  Container(
                    height: 2.0,
                    color: Colors.orange,
                  ),
                  SizedBox(height: 10.0),

                  // Bottom note or footer (optional)
                  Text(
                    'Thank you for your booking!',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'For inquiries, contact us at support@hotel.com',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            if (widget.booking['completed'] == true) {
              // If the booking is completed, show the delete button instead
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Delete Booking'),
                  content: Text('Are you sure you want to delete this booking permanently?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await deleteBooking(context);  // Call the delete function
                        Navigator.of(context).pop(true);  // Close the dialog
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );
            } else {
              bool? confirmMove = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Move to Completed'),
                  content: Text('Are you sure you want to move this booking to the completed list?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Move'),
                    ),
                  ],
                ),
              );

              if (confirmMove == true) {
                await moveToCompleted(context);  // Call the move function
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.booking['completed'] == true ? Colors.red : Colors.green,
            padding: EdgeInsets.symmetric(vertical: 16.0),
            textStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          child: Text(
              widget.booking['completed'] == true ? 'Delete Booking' : 'Move to Completed',style: TextStyle(
            color: Colors.white
          ),),
        ),
      ),
    );
  }
}

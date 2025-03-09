import 'package:cimso_heckathon/reservations/reservation_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class BookedItemsScreen extends StatefulWidget {
  @override
  _BookedItemsScreenState createState() => _BookedItemsScreenState();
}

class _BookedItemsScreenState extends State<BookedItemsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<List<Map<String, dynamic>>>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _bookingsFuture = fetchBookings(); // Initial bookings fetch
  }

  // Fetch bookings and split by upcoming/completed status
  Future<List<List<Map<String, dynamic>>>> fetchBookings() async {
    User? user = FirebaseAuth.instance.currentUser;
    List<Map<String, dynamic>> upcomingBookings = [];
    List<Map<String, dynamic>> completedBookings = [];

    if (user != null) {
      try {
        // Fetch the reservations subcollection for the user by using uid
        QuerySnapshot reservationsSnapshot = await FirebaseFirestore.instance
            .collection('members') // Ensure collection name is correct
            .doc(user.uid) // Using the user's uid to directly get their data
            .collection('reservations')
            .orderBy('bookingDate', descending: true) // Order by booking date
            .get();

        // Map the fetched data to a list of maps and separate by completed status
        for (var doc in reservationsSnapshot.docs) {
          Map<String, dynamic> booking = doc.data() as Map<String, dynamic>;
          if (booking['completed'] == true) {
            completedBookings.add(booking);
          } else {
            upcomingBookings.add(booking);
          }
        }
      } catch (e) {
      }
    }
    return [upcomingBookings, completedBookings]; // Correct return type
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4.0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Container(
        color: Colors.lightGreen,
        child: TabBarView(
          
          controller: _tabController,
          children: [
            // Upcoming Tab
            FutureBuilder<List<List<Map<String, dynamic>>>>(
              future: _bookingsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error fetching bookings'));
                } else if (!snapshot.hasData || snapshot.data![0].isEmpty) {
                  return Center(child: Text('No upcoming bookings found'));
                } else {
                  List<Map<String, dynamic>> upcomingBookings = snapshot.data![0];
                  return ListView.builder(
                    itemCount: upcomingBookings.length,
                    itemBuilder: (context, index) {
                      var booking = upcomingBookings[index];
                      DateFormat dateFormat = DateFormat('dd-MM-yyyy');
                      String checkInDate = dateFormat.format(booking['checkInDate'].toDate());
                      String checkOutDate = dateFormat.format(booking['checkOutDate'].toDate());
        
                      String hotelName = booking['hotelName'];
                      String hotelImage = "assets/images/${hotelName.split(' ')[0].toLowerCase()}.jpeg";
        
                      return Container(
                        height: 200,
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          elevation: 8.0, // Elevated card
                          color: Colors.white, // Color for upcoming booking (blue)
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: InkWell(
                            onTap: () async {
                              // Pass refresh function to details screen
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookingDetailsScreen(
                                    booking: booking,
                                  ),
                                ),
                              );
                              // Refresh after coming back from the details screen
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  ClipOval(
                                    child: Image.asset(
                                      hotelImage,
                                      width: 120.0,
                                      height: 130.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          booking['hotelName'],
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.teal,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          'Check-in: $checkInDate',
                                          style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Check-out: $checkOutDate',
                                          style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 8.0),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Total Price: \$${booking['totalPrice']}',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.teal,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
        
            // Completed Tab
            FutureBuilder<List<List<Map<String, dynamic>>>>(
              future: _bookingsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error fetching bookings'));
                } else if (!snapshot.hasData || snapshot.data![1].isEmpty) {
                  return Center(child: Text('No completed bookings found'));
                } else {
                  List<Map<String, dynamic>> completedBookings = snapshot.data![1];
                  return ListView.builder(
                    itemCount: completedBookings.length,
                    itemBuilder: (context, index) {
                      var booking = completedBookings[index];
                      DateFormat dateFormat = DateFormat('yyyy-MM-dd');
                      String checkInDate = dateFormat.format(booking['checkInDate'].toDate());
                      String checkOutDate = dateFormat.format(booking['checkOutDate'].toDate());
        
                      String hotelName = booking['hotelName'];
                      String hotelImage = "assets/images/${hotelName.split(' ')[0].toLowerCase()}.jpeg";
        
                      return Container(
                        height: 200,
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          elevation: 8.0, // Elevated card
                          color: Colors.redAccent[100], // Color for completed booking (red)
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: InkWell(
                            onTap: () async {
                              // Pass refresh function to details screen
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookingDetailsScreen(
                                    booking: booking,
                                  ),
                                ),
                              );
                              // Refresh after coming back from the details screen
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  ClipOval(
                                    child: Image.asset(
                                      hotelImage,
                                      width: 120.0,
                                      height: 130.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          booking['hotelName'],
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          'Check-in: $checkInDate',
                                          style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Check-out: $checkOutDate',
                                          style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 8.0),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Total Price: \$${booking['totalPrice']}',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.teal,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cimso_heckathon/hotel/payment_finished.dart';
import 'package:cimso_heckathon/hotel/payment_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/hotel.dart';
import '../model/receipt.dart';
import '../statements/statement.dart';
import '../service/firebase_service.dart';

class HotelDetailPage extends StatefulWidget {
  final Hotel hotel;

  const HotelDetailPage({required this.hotel});

  @override
  _HotelDetailPageState createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage> {
  final TextEditingController _checkInController = TextEditingController();
  final TextEditingController _checkOutController = TextEditingController();

  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _days = 0;
  double _totalPrice = 0.0;

  String? _bedType = "Double"; // Default selection
  bool _breakfastIncluded = false;
  int _guests = 1; // Default number of guests is 1

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = isCheckIn ? DateTime.now() : _checkInDate ?? DateTime.now();  // Block past dates for check-in, and check-out starts from check-in date
    DateTime lastDate = DateTime(2100);
    if (isCheckIn) {
      initialDate = DateTime.now();
    } else if (_checkInDate != null) {
      initialDate = _checkInDate!;
    }
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      if (isCheckIn) {
        setState(() {
          _checkInDate = pickedDate;
          _checkInController.text = formattedDate;
        });
      } else {
        setState(() {
          _checkOutDate = pickedDate;
          _checkOutController.text = formattedDate;
        });
      }

      if (_checkInDate != null && _checkOutDate != null) {
        _calculateDaysAndPrice();
      }
    }
  }

  void _calculateDaysAndPrice() {
    if (_checkInDate != null && _checkOutDate != null) {
      Duration difference = _checkOutDate!.difference(_checkInDate!);
      setState(() {
        _days = difference.inDays;
        if (_days > 0) {
          _totalPrice = _days * widget.hotel.price;
        } else {
          _totalPrice = 0.0;
        }

        // Add breakfast cost if selected
        if (_breakfastIncluded) {
          _totalPrice += _days * 20.0; // Assume breakfast adds $20 per night
        }

        // Add extra cost for bed type selection
        if (_bedType == "Double") {
          _totalPrice += _days * 10.0; // Double bed costs $10 more per night
        } else if (_bedType == "Twin") {
          _totalPrice += _days * 5.0; // Twin bed costs $5 more per night
        }

        // Add extra cost for number of guests
        _totalPrice *= _guests; // Multiply total by the number of guests
      });
    }
  }

  Future<String?> getMemberID() async {
    String? currentUserID = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserID == null) {
      return null;
    }

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('members')
          .doc(currentUserID) // Use the user's UID to fetch their member document
          .get();

      if (userDoc.exists) {
        // Assuming that the memberID is inside the document
        return userDoc['memberID'] ;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
  Future<String?> getName() async {
    String? currentUserID = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserID == null) {
      return null;
    }

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('members')
          .doc(currentUserID) // Use the user's UID to fetch their member document
          .get();

      if (userDoc.exists) {
        // Assuming that the memberID is inside the document
        return userDoc['fullName'] ;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }


  Future<void> _saveReceiptToFirebase() async {
    if (_checkInDate != null && _checkOutDate != null && _days > 0) {
      Receipt receipt = Receipt(
        hotelName: widget.hotel.name,
        location: widget.hotel.location,
        checkInDate: _checkInDate!,
        checkOutDate: _checkOutDate!,
        guests: _guests,
        bedType: _bedType!,
        breakfastIncluded: _breakfastIncluded,
        totalPrice: _totalPrice,
        completed: false,
      );

      try {
        FirestoreService firestoreService = FirestoreService();

        // Save receipt for the current user
        await firestoreService.saveReceiptForUser(
          hotelName: receipt.hotelName,
          location: receipt.location,
          checkInDate: receipt.checkInDate,
          checkOutDate: receipt.checkOutDate,
          guests: receipt.guests,
          bedType: receipt.bedType,
          breakfastIncluded: receipt.breakfastIncluded,
          totalPrice: receipt.totalPrice,
        );
        String? memberID = await getMemberID();
        String? userName = await getName();



        Statement statement = Statement(
          hotelName: widget.hotel.name,
          user: userName!,
          amount: _totalPrice,
          type: 'Transfer', // Statement type could be "Booking" or similar
          memberID: memberID!, // Replace "userID" with the current user's ID (Firebase UID)
          date: DateTime.now(),
        );

        // Save statement for the current user
        await firestoreService.saveStatementForUser(statement);

        // // Optionally show a success message
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Booking confirmed!')),
        // );
      } catch (e) {
        // Handle error
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Failed to save booking. Please try again later.')),
        // );
      }
    }
  }

  void _handleBooking() async {
    await _saveReceiptToFirebase();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          hotel: widget.hotel,
          checkInDate: _checkInDate!,
          checkOutDate: _checkOutDate!,
          days: _days,
          totalPrice: _totalPrice,
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double imageHeight = screenHeight / 2.5; // Adjusted image height

    return Scaffold(

      appBar: AppBar(
        title: Text(widget.hotel.name, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.lightGreen,

        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotel Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                widget.hotel.image,
                width: double.infinity,
                height: imageHeight,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),

            // Hotel Name and Location
            Text(
              widget.hotel.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey, size: 16),
                SizedBox(width: 5),
                Text(
                  widget.hotel.location,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "Type: ${widget.hotel.type}",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),

            // Price Per Night in a Card
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  "Price Per Night: \$${widget.hotel.price}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800]),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Check-in and Check-out Calendar
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, true),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _checkInController,
                        decoration: InputDecoration(
                          labelText: "Check-in",
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, false),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _checkOutController,
                        decoration: InputDecoration(
                          labelText: "Check-out",
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Number of Days: $_days",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Number of Guests",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    DropdownButtonFormField<int>(
                      value: _guests,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      items: List.generate(5, (index) {
                        return DropdownMenuItem<int>(
                          value: index + 1,
                          child: Text("${index + 1} guest${index == 0 ? '' : 's'}"),
                        );
                      }),
                      onChanged: (value) {
                        setState(() {
                          _guests = value!;
                          _calculateDaysAndPrice();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Bed Type Selection in a Card
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Choose Bed Type",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        RadioListTile<String>(
                          title: Text("Double Bed"),
                          value: "Double",
                          groupValue: _bedType,
                          onChanged: (value) {
                            setState(() {
                              _bedType = value;
                              _calculateDaysAndPrice();
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: Text("Twin Bed"),
                          value: "Twin",
                          groupValue: _bedType,
                          onChanged: (value) {
                            setState(() {
                              _bedType = value;
                              _calculateDaysAndPrice();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),

            // Breakfast Option in a Card
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Text("Breakfast Included: "),
                    Switch(
                      value: _breakfastIncluded,
                      onChanged: (value) {
                        setState(() {
                          _breakfastIncluded = value;
                          _calculateDaysAndPrice();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Total Price and Booking Button
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Price: \$${_totalPrice.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange[800]),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _handleBooking,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50), backgroundColor: Colors.greenAccent[800],
                      ),
                      child: Text('Proceed to Booking'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

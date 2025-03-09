import 'package:cimso_heckathon/vouchers/voucher_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VoucherCardsPage extends StatefulWidget {
  @override
  _VoucherCardsPageState createState() => _VoucherCardsPageState();
}

class _VoucherCardsPageState extends State<VoucherCardsPage> {
  final List<Voucher> vouchers = [
    Voucher(
      voucherID: 'VOUCHER001',
      voucherType: 'Discount',
      voucherValue: 20.0,
      expirationDate: DateTime(2025, 12, 31),
      isActive: true,
      description: '20% off for next hotel booking',
    ),

    Voucher(
      voucherID: 'VOUCHER003',
      voucherType: 'Free Night',
      voucherValue: 1.0,
      expirationDate: DateTime(2025, 8, 20),
      isActive: true,
      description: 'Get one free night with your booking',
    ),
    Voucher(
      voucherID: 'VOUCHER004',
      voucherType: 'Discount',
      voucherValue: 10.0,
      expirationDate: DateTime(2025, 3, 5),
      isActive: false, // Expired
      description: '10% off on any reservation',
    ),
  ];

  List<Voucher> remainingVouchers = [];
  List<Voucher> expiredVouchers = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _memberIDController = TextEditingController();
  TextEditingController _clientIDController = TextEditingController();

  String _profilePicUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _separateVouchers();
  }

  _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('members').doc(user.uid).get();

      // Set data to controllers
      _nameController.text = userDoc['fullName'] ?? '';
      _emailController.text = userDoc['email'] ?? ''; // Email from Firestore
      _memberIDController.text = userDoc['memberID'] ?? ''; // Fetch memberID
      _clientIDController.text = userDoc['clientID'] ?? ''; // Fetch clientID
      _profilePicUrl = userDoc['profilePicture'] ?? ''; // Default to empty string if no profile picture

      setState(() {});
    }
  }

  // Separate vouchers into expired and remaining
  _separateVouchers() {
    DateTime now = DateTime.now();
    remainingVouchers = vouchers.where((voucher) => voucher.expirationDate.isAfter(now) && voucher.isActive).toList();
    expiredVouchers = vouchers.where((voucher) => voucher.expirationDate.isBefore(now) || !voucher.isActive).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voucher'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.lightGreen,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 5.0,
              color: Color(0xFFE8F5E9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    _profilePicUrl.isNotEmpty
                        ? CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(_profilePicUrl),
                    )
                        : Image.asset(
                      "assets/images/cimsocircle.jpeg",
                      width: 130,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _nameController.text,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF388E3C),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Member ID: ${_memberIDController.text}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "Client ID: ${_clientIDController.text}",
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
            // Remaining Vouchers
            if (remainingVouchers.isNotEmpty)
              Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Remaining Vouchers',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: remainingVouchers.length,
                      itemBuilder: (context, index) {
                        Voucher voucher = remainingVouchers[index];
                        return VoucherCard(
                          voucher: voucher,
                          onTap: () {
                            if (voucher.isActive) {
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Voucher Expired'),
                                  content: Text('This voucher has expired and cannot be used.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            // Expired Vouchers
            if (expiredVouchers.isNotEmpty)
              Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Expired Vouchers',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: expiredVouchers.length,
                      itemBuilder: (context, index) {
                        Voucher voucher = expiredVouchers[index];
                        return VoucherCard(
                          voucher: voucher,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Voucher Expired'),
                                content: Text('This voucher has expired and cannot be used.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

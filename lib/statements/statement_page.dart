import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatementPage extends StatefulWidget {
  @override
  _StatementPageState createState() => _StatementPageState();
}

class _StatementPageState extends State<StatementPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  bool _hasError = false;
  List<Map<String, dynamic>> _statements = [];
  List<Map<String, dynamic>> groupedStatements = [];

  @override
  void initState() {
    super.initState();
    _fetchStatements();
  }

  // Fetch statements from Firestore
  Future<void> _fetchStatements() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        QuerySnapshot statementsSnapshot = await _firestore
            .collection('members')
            .doc(user.uid)
            .collection('statements')
            .orderBy('date', descending: true)
            .get();

        setState(() {
          _statements = statementsSnapshot.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>; // Ensure it's a Map

            return {
              'date': (data['date'] as Timestamp).toDate(),
              'user': data['user'] ?? 'Unknown User',
              'amount': data['amount'] ?? 0,
              'type': data['type'] ?? 'Unknown',
              'memberID': data['memberID'] ?? 'No ID',
              'details': data['details'] ?? 'No additional details available',
              'hotelName': data['hotelName'] ?? 'No hotel booked', // Safe retrieval
            };
          }).toList();
          _isLoading = false;
          _hasError = false;
          _groupStatementsByMonth();
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  // Group statements by month
  void _groupStatementsByMonth() {
    Map<String, List<Map<String, dynamic>>> monthGroupedStatements = {};

    for (var statement in _statements) {
      // Extract month and year from the statement date
      String monthYear = DateFormat('MMMM yyyy').format(statement['date']);

      // Group the statements by monthYear
      if (!monthGroupedStatements.containsKey(monthYear)) {
        monthGroupedStatements[monthYear] = [];
      }
      monthGroupedStatements[monthYear]!.add(statement);
    }

    setState(() {
      groupedStatements = monthGroupedStatements.entries.map((entry) {
        return {
          'monthYear': entry.key,
          'statements': entry.value,
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Color> depositColor = [Colors.green, Colors.white54];
    List<Color> transferColor = [Colors.red, Colors.white54];
    return Scaffold(
      appBar: AppBar(
        title: Text('Statements'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _hasError
          ? Center(child: Text('Failed to fetch statements. Please try again later.'))
          : groupedStatements.isEmpty
          ? Center(child: Text('No statements available.'))
          : ListView.builder(
        itemCount: groupedStatements.length,
        itemBuilder: (context, index) {
          var monthGroup = groupedStatements[index];
          String monthYear = monthGroup['monthYear'];
          var statements = monthGroup['statements'];

          return Column(
            children: [
              ListTile(
                title: Text(monthYear, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: statements.length,
                itemBuilder: (context, idx) {
                  var statement = statements[idx];
                  String formattedDate = DateFormat('dd-MM-yyyy').format(statement['date']);
                  return Container(
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: (statement['type'] == 'Transfer') ? transferColor:depositColor),
                      border: Border.all(color: Colors.black, width: 2), // Border style
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.all(12.0),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${statement['type']}",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$ ${statement['amount']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      children: [
                           Align(
                             alignment: Alignment.bottomLeft,
                             child: Padding(
                               padding: EdgeInsets.only(left: 16,bottom: 16),
                               child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Date: $formattedDate', style: TextStyle(fontSize: 16)),
                                  SizedBox(height: 8),
                                  Text('Member ID: ${statement['memberID']}', style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Text('Booked Hotel: ${statement['hotelName']}', style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                                ],
                                                         ),
                             ),
                           ),

                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StatementPage extends StatefulWidget {
  @override
  _StatementPageState createState() => _StatementPageState();
}

class _StatementPageState extends State<StatementPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  List<Map<String, dynamic>> _statements = [];

  @override
  void initState() {
    super.initState();
    _fetchStatements();
  }

  // Fetch statements from Firestore and filter by memberId in code
  Future<void> _fetchStatements() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Fetch all statements from Firestore
        QuerySnapshot snapshot = await _firestore.collection('statements').get();

        // Filter the statements by memberId and sort by date in code
        setState(() {
          _statements = snapshot.docs
              .where((doc) => doc['memberId'] == user.uid) // Filter by memberId
              .map((doc) {
            return {
              'date': (doc['date'] as Timestamp).toDate(),
              'amount': doc['amount'],
              'type': doc['type'],
              'description': doc['description'],
            };
          })
              .toList();

          // Sort statements by date (descending order)
          _statements.sort((a, b) => b['date'].compareTo(a['date']));

          _isLoading = false;
        });
      } catch (e) {
        print("Error fetching statements: $e");
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Statements'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while data is being fetched
          : _statements.isEmpty
          ? Center(child: Text('No statements available.')) // If no statements exist
          : ListView.builder(
        itemCount: _statements.length,
        itemBuilder: (context, index) {
          var statement = _statements[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 5.0,
            child: ListTile(
              contentPadding: EdgeInsets.all(12.0),
              title: Text(
                '${statement['type']} - \$${statement['amount']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: ${statement['date']}'),
                  SizedBox(height: 4.0),
                  Text(
                    'Description: ${statement['description']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // You could add navigation to a detailed view of the statement here
                print('Tapped on statement: ${statement['description']}');
              },
            ),
          );
        },
      ),
    );
  }
}

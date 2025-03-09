import 'package:cimso_heckathon/hotel/payment_finished.dart';
import 'package:flutter/material.dart';
import 'package:u_credit_card/u_credit_card.dart';

import '../model/hotel.dart';

class PaymentPage extends StatefulWidget {
  final Hotel hotel;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int days;
  final double totalPrice;

  const PaymentPage({
    super.key,
    required this.hotel,
    required this.checkInDate,
    required this.checkOutDate,
    required this.days,
    required this.totalPrice,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cardHolderController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController validForm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Default values to pass to CreditCardUi
    String cardHolderName = cardHolderController.text;
    String cardNumber = cardNumberController.text;
    String expiryDate = expiryDateController.text;
    String cvvControllerString = cvvController.text;
    String validFormString = validForm.text;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
        title: const Text("Payment Checkout"),
      ),
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CreditCardUi(
              width: double.maxFinite,
              cardHolderFullName: cardHolderName,
              cardNumber: cardNumber,
              validThru: expiryDate,
              validFrom: validFormString,
              cvvNumber: cvvControllerString,
              topLeftColor: Colors.blueAccent,
              placeNfcIconAtTheEnd: true,
              enableFlipping: true,
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        cardHolderName = value;
                      });
                    },
                    controller: cardHolderController,
                    decoration: const InputDecoration(
                      labelText: 'Card Holder Full Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter full name' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: cardNumberController,
                    onChanged: (value) {
                      setState(() {
                        cardNumber = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Card Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    validator: (value) {
                      if (value == null || value.length != 16) {
                        return 'Card number must be 16 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    maxLength: 5,
                    controller: expiryDateController,
                    onChanged: (value) {
                      setState(() {
                        expiryDate = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Expiry Date (MM/YY)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                    validator: (value) =>
                    value!.isEmpty ? 'Please enter expiry date' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: cvvController,
                    onChanged: (value) {
                      setState(() {
                        cvvControllerString = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    validator: (value) {
                      if (value == null || value.length != 3) {
                        return 'CVV must be 3 digits';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: validForm,
                    onChanged: (value) {
                      setState(() {
                        validFormString = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Valid From ',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    validator: (value) {
                      if (value == null || value.length != 5) {
                        return 'Fill the exact format (MM/YY)';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Validate the form
                      if (_formKey.currentState?.validate() ?? false) {
                        // If form is valid, navigate to PaymentFinishedPage
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => PaymentFinishedPage()),
                              (route) => false,
                        );
                      }
                    },
                    child: const Text('Confirm Payment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
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
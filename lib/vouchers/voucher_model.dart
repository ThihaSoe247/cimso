import 'package:flutter/material.dart';

class Voucher {
  final String voucherID;
  final String voucherType;
  final double voucherValue;
  final DateTime expirationDate;
  final bool isActive;
  final String description;

  Voucher({
    required this.voucherID,
    required this.voucherType,
    required this.voucherValue,
    required this.expirationDate,
    required this.isActive,
    required this.description,
  });

  String getFormattedExpirationDate() {
    return '${expirationDate.day}/${expirationDate.month}/${expirationDate.year}';
  }
}

class VoucherCard extends StatelessWidget {
  final Voucher voucher;
  final Function onTap;

  VoucherCard({required this.voucher, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: voucher.isActive ? Colors.green : Colors.red,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: voucher.isActive
                ? [Colors.green.shade100, Colors.green.shade400]
                : [Colors.red.shade100, Colors.red.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          title: Text(
            voucher.description,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Voucher Type: ${voucher.voucherType}'),
              Text('Value: \$${voucher.voucherValue.toString()}'),
              Text('Expires on: ${voucher.getFormattedExpirationDate()}'),
              if (!voucher.isActive)
                Text(
                  'Expired',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
            ],
          ),
          onTap: () => onTap(),
          trailing: TextButton(onPressed: () {}, child: Text("Claim")),
        ),
      ),
    );
  }
}

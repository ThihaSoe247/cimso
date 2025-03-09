import 'package:intl/intl.dart';

class Receipt {
  final String hotelName;
  final String location;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guests;
  final String bedType;
  final bool breakfastIncluded;
  final double totalPrice;
  bool completed;  // Changed to allow modification

  Receipt({
    required this.hotelName,
    required this.location,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guests,
    required this.bedType,
    required this.breakfastIncluded,
    required this.totalPrice,
    this.completed = false, // Default to false but can be modified later
  });

  // Method to mark the receipt as completed
  void markAsCompleted() {
    completed = true;
  }

  @override
  String toString() {
    return '''
    Hotel: $hotelName
    Location: $location
    Check-in: ${DateFormat('yyyy-MM-dd').format(checkInDate)}
    Check-out: ${DateFormat('yyyy-MM-dd').format(checkOutDate)}
    Guests: $guests
    Bed Type: $bedType
    Breakfast Included: ${breakfastIncluded ? "Yes" : "No"}
    Total Price: \$${totalPrice.toStringAsFixed(2)}
    Completed: ${completed ? "Yes" : "No"}
    ''';
  }
}

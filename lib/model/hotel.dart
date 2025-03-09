class Hotel {
  final String name;
  final String location;
  final String image;
  final double price;
  final String type; // New field added

  Hotel({
    required this.name,
    required this.location,
    required this.image,
    required this.price,
    required this.type, // New field
  });
}
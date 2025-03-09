import 'package:flutter/material.dart';
import '../constants.dart';
import '../model/hotel.dart';
import 'detail_booking.dart';

class HotelListPage extends StatefulWidget {
  @override
  _HotelListPageState createState() => _HotelListPageState();
}

class _HotelListPageState extends State<HotelListPage> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.lightGreen,
        appBar: AppBar(
          title: Text("Choose a Stay"),
          backgroundColor: Colors.white,
          elevation: 4,
          bottom: TabBar(
            tabs: [
              Tab(text: "Hotels"),
              Tab(text: "Golf Resort"),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search by hotel name or city...",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildHotelList(hotels),
                  _buildHotelList(golfResorts),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHotelList(List<Hotel> hotels) {
    List<Hotel> filteredHotels = hotels.where((hotel) {
      return hotel.name.toLowerCase().contains(searchQuery) ||
          hotel.location.toLowerCase().contains(searchQuery);
    }).toList();

    return ListView.builder(
      itemCount: filteredHotels.length,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      itemBuilder: (context, index) {
        final hotel = filteredHotels[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HotelDetailPage(hotel: hotel),
              ),
            );
          },
          child: Card(
            elevation: 6,
            shadowColor: Colors.grey,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade50, Colors.green.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(hotel.image, width: 120, height: 120, fit: BoxFit.cover),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hotel.name,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue.shade800),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 16, color: Colors.redAccent),
                            SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                hotel.location,
                                style: TextStyle(color: Colors.grey[700], fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Type: ${hotel.type}",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$${hotel.price}/night",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green.shade700),
                            ),
                            IconButton(
                              icon: Icon(Icons.favorite_border, color: Colors.red),
                              onPressed: () {},
                              splashRadius: 22,
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
        );
      },
    );
  }
}

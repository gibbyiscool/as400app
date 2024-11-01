import 'package:as400app/DatabaseManagerAndCreators/OrderManager.dart';
import 'package:as400app/DatabaseManagerAndCreators/TruckManager.dart';
import 'package:flutter/material.dart';
import 'DatabaseManagerAndCreators/CustomerMana.dart';
import 'MainMenu.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'DatabaseManagerAndCreators/Database.dart';
import 'package:path/path.dart';
import 'dart:ui';


class AdminMenuPage extends StatefulWidget {
  @override
  _AdminMenuPageState createState() => _AdminMenuPageState();
}

class _AdminMenuPageState extends State<AdminMenuPage> {
  TextEditingController _searchController = TextEditingController();
  List<String> menuItems = ["Truck", "Trailer", "Order", "Customer", "Settings"];
  List<String> databaseEntries = [];
  List<String> filteredEntries = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadDatabaseEntries();
  }

  Future<void> _loadDatabaseEntries() async {
    final truckNumbers = await TruckDatabase().getAllTruckNumbers();
    final orderNumbers = await OrderDatabase().getAllOrderNumbers();
    final customerCodes = await CustomerDatabase().getAllCustomerCodes();

    setState(() {
      databaseEntries = [...truckNumbers, ...orderNumbers, ...customerCodes];
    });
  }

  void _onSearchChanged() {
    setState(() {
      filteredEntries = databaseEntries
          .where((entry) => entry.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Menu'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _showLogoutConfirmation(context),
          ),
        ],
      ),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Truck, Trailer, Order, Customer, or Settings...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Expanded(
  child: ListView.builder(
    itemCount: filteredEntries.isEmpty ? databaseEntries.length : filteredEntries.length,
    itemBuilder: (context, index) {
      String entry = filteredEntries.isEmpty ? databaseEntries[index] : filteredEntries[index];
      return Builder(
        builder: (BuildContext tileContext) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: ListTile(
              title: Text(entry),
              onTap: () => _navigateToDetail(tileContext, entry),
            ),
          );
        },
      );
    },
  ),
),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: Colors.grey[900]!.withOpacity(0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircleAvatar(
              child: Icon(Icons.home),
              radius: 24,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return IconButton(
                  icon: Icon(_getIconForMenu(menuItems[index])),
                  tooltip: menuItems[index],
                  onPressed: () {
                    switch (menuItems[index]) {
                      case "Truck":
                        Navigator.pushNamed(context, '/truckLookupScreen');
                        break;
                      case "Trailer":
                        // No action specified for Trailer
                        break;
                      case "Order":
                        Navigator.pushNamed(context, '/orderLookupScreen');
                        break;
                      case "Customer":
                        Navigator.pushNamed(context, '/customerLookupScreen');
                        break;
                      case "Settings":
                        //Navigator.pushNamed(context, '/adminMenuPage');
                        break;
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForMenu(String menuItem) {
    switch (menuItem) {
      case "Truck":
        return Icons.local_shipping;
      case "Trailer":
        return Icons.local_airport;
      case "Order":
        return Icons.list_alt;
      case "Customer":
        return Icons.person;
      case "Settings":
        return Icons.settings;
      default:
        return Icons.help;
    }
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to go back to the login page?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Navigate back to login page
              Navigator.of(context).pop();
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
void _navigateToDetail(BuildContext context, String entry) async {
  if (await TruckDatabase().getTruck(entry) != null) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TruckLookupScreen(truckNumber: entry)),
    );
  } else if (await OrderDatabase().getOrder(entry) != null) {
    //Navigator.push(
    //context,
    //MaterialPageRoute(builder: (context) => OrderLookupScreen(orderNumber: entry,)),
    //);
    print('Navigating to Order detail of: $entry');
  } else if (await CustomerDatabase().getCustomer(entry) != null) {
    // Navigate to Customer detail screen (placeholder for now)
    print('Navigating to Customer detail of: $entry');
  } else {
    // If entry is empty or doesn't match, allow general TruckLookupScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TruckLookupScreen()),
    );
  }
}



  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

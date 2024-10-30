import 'package:as400app/LogIn.dart';
import 'DatabaseManagerAndCreators/OrderLook.dart';
import 'DatabaseManagerAndCreators/OrderManager.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'DatabaseManagerAndCreators/CustomerMana.dart';
import 'TruckScreen.dart';
import 'MainMenu.dart';
import 'DispatchMenu.dart';
import 'DatabaseManagerAndCreators/TruckManager.dart';

void main() {
  // Initialize the database for non-mobile platforms
  if (!Platform.isAndroid && !Platform.isIOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(YourApp());
}

class YourApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomerLookupScreen(),
      routes: {
        '/orderCreatorScreen': (context) => OrderCreatorScreen(),
        '/logInView' : (context) => LogInView(),
        '/orderLookupScreen': (context) => OrderLookupScreen(),
        '/customerCreatorScreen': (context) => CustomerCreatorScreen(),
        '/mainMenu': (context) => MainMenu(),
        '/dispatchServiceMenu': (context) => DispatchServiceMenu(),
        '/customerDetailsScreen': (context) => CustomerLookupScreen(),  // Replace with the proper screen
        '/truckScreen': (context) => TruckScreen(), // If you have a truck screen
        

        
      },
    );
  }
}

import 'package:as400app/InactiveMenu.dart';
import 'package:as400app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:as400app/MainMenu.dart';
import 'package:as400app/TruckScreen.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LogInView(),
      routes: {
        '/dispatchServiceMenu': (context) => DispatchServiceMenu(),
        '/mainMenu':(context) => MainMenu()
      },
    ));

class DispatchServiceMenu extends StatefulWidget {
  @override
  _DispatchServiceMenuState createState() => _DispatchServiceMenuState();
}

class _DispatchServiceMenuState extends State<DispatchServiceMenu> {
  String option = '';
  late Timer timer;
  FocusNode _focusNode = FocusNode();
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  final int _totalOptions = 54;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _updateTimeEveryMinute();
  }

  void _updateTimeEveryMinute() {
    timer = Timer.periodic(Duration(minutes: 1), (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    timer.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    return '${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}/${now.year.toString().substring(2)}';
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  void navigateToMenu(String input) {
    switch (input) {
      case '90':
        Navigator.of(context).popUntil((route) => route.isFirst);
        break;
      case '3':
        Navigator.push(context, MaterialPageRoute(builder: (context) => TruckScreen()));
        break;
      default:
        if (int.tryParse(input) != null && int.parse(input) >= 1 && int.parse(input) <= _totalOptions) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => InactiveMenu()));
        } else {
          setState(() {
            option = '';
          });
        }
        break;
    }
  }

  void _nextPage() {
    setState(() {
      if ((_currentPage + 1) * _itemsPerPage < _totalOptions) {
        _currentPage++;
      }
    });
  }

  void _previousPage() {
    setState(() {
      if (_currentPage > 0) {
        _currentPage--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.f3 && Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else if (event.logicalKey == LogicalKeyboardKey.pageDown) {
              _nextPage();
            } else if (event.logicalKey == LogicalKeyboardKey.pageUp) {
              _previousPage();
            }
          }
        },
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double aspectRatio = 4 / 3;
              double width = constraints.maxWidth;
              double height = constraints.maxHeight;
              double adjustedWidth = width < height * aspectRatio ? width : height * aspectRatio;
              double fontSize = adjustedWidth / 35;

              return Container(
                width: adjustedWidth,
                child: Stack(
                  children: [
                    Positioned(
                      top: 16.0,
                      right: 16.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${_getCurrentDate()}',
                            style: TextStyle(color: Colors.white, fontFamily: 'Courier', fontSize: fontSize / 1.4),
                          ),
                          Text(
                            '${_getCurrentTime()}',
                            style: TextStyle(color: Colors.white, fontFamily: 'Courier', fontSize: fontSize / 1.4),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 16.0,
                      left: 0.0,
                      right: 0.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Western Express, Inc.',
                            style: TextStyle(color: Colors.white, fontFamily: 'Courier', fontSize: fontSize),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: adjustedWidth * 0.43,
                            height: adjustedWidth / 25,
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
                            child: Text(
                              'DISPATCH SERVICE',
                              style: TextStyle(color: Colors.black, fontFamily: 'Courier', fontSize: fontSize),
                            ),
                          ),
                          Text(
                            '©2003,2024 Trimble Inc. All rights reserved.',
                            style: TextStyle(color: Colors.blue, fontFamily: 'Courier', fontSize: fontSize / 1.2),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        width: adjustedWidth * 0.7,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            Text(
                              'Select one of the following:',
                              style: TextStyle(color: Colors.blue, fontFamily: 'Courier', fontSize: fontSize / 1.2),
                            ),
                            SizedBox(height: 8),
                            ...List.generate(
                              _itemsPerPage,
                              (index) {
                                int optionNumber = _currentPage * _itemsPerPage + index + 1;
                                if (optionNumber > _totalOptions) return SizedBox();
                                return RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '$optionNumber. ',
                                        style: TextStyle(color: Colors.white, fontFamily: 'Courier', fontSize: fontSize),
                                      ),
                                      TextSpan(
                                        text: _getMenuOption(optionNumber),
                                        style: TextStyle(color: const Color.fromARGB(255, 92, 216, 96), fontFamily: 'Courier', fontSize: fontSize),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16.0,
                      left: 16.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Option',
                            style: TextStyle(color: const Color.fromARGB(255, 92, 216, 96), fontFamily: 'Courier', fontSize: fontSize),
                          ),
                          SizedBox(
                            width: adjustedWidth * 0.05, // Adjusted to maintain consistent sizing
                            child: TextField(
                              style: TextStyle(color: const Color.fromARGB(255, 92, 216, 96), fontFamily: 'Courier', fontSize: fontSize),
                              cursorColor: Colors.white,
                              maxLength: 2,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 8),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                counterText: '',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  option = value;
                                });
                              },
                              onSubmitted: navigateToMenu,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _getMenuOption(int optionNumber) {
    switch (optionNumber) {
      case 1:
        return 'Tractors by Supervisor';
      case 2:
        return 'Tractor by Destination Area';
      case 3:
        return 'Check Call Entry';
      case 4:
        return 'Display Previous Check Calls';
      case 5:
        return 'Display Tractors/Orders by Type';
      case 6:
        return 'Preplan Orders & Tractors';
      case 7:
        return 'Display Order History';
      case 8:
        return 'Customer Directions & Comments';
      case 9:
        return 'Message Entry';
      case 10:
        return 'Update Driver/Tractor/Trailer Status';
      // Additional options up to 54
      case 11:
        return 'Assign Available Units and Drivers';
      case 12:
        return 'Display Customer/Driver Codes';
      case 13:
        return 'Partial Order Update';
      case 14:
        return 'Load Offering Inquiry';
      case 15:
        return 'Display Equipment Status';
      case 16:
        return 'Display Available Tractors';
      case 17:
        return 'Display Unassigned Tractors - No Driv';
      case 18:
        return 'Display Unassigned Drivers';
      case 19:
        return 'Display Units in the Shop';
      case 20:
        return 'Display Available Trailers';
      case 21:
        return 'Display Available Containers';
      case 22:
        return 'Display Available Drivers';
      case 23:
        return 'Driver Comments Entry/Update';
      case 24:
        return '';
      case 25:
        return 'Display Trk/Tri/Drv Movement';
      case 26:
        return 'Display Dispatch Information';
      case 27:
        return 'Display Closest Trucks';
      case 28:
        return 'Display Closest Orders to a Truck';
      case 29:
        return 'Quick Dispatch (Short Haul)';
      case 30:
        return 'Display Equipment Wash History';
      case 31:
        return 'Trailer Wash Call';
      case 32:
        return 'EnRoute Drop and Hook';
      case 33:
        return 'Flexible Driver Manager Display';
      case 34:
        return 'Fleet Manager Board';
      case 35:
        return 'Gate & Yard Check-In';
      case 36:
        return 'Yard Inquiry';
      case 37:
        return 'Work with Yard Check Audit File';
      case 38:
        return 'Service Failure Inquiry';
      case 39:
        return 'Service Failure Inquiry-Pending';
      case 40:
        return 'Service Failure Inquiry by Customer';
      case 41:
        return 'Tractors Status Report';
      case 42:
        return 'Unit-Load Matching Report';
      case 43:
        return 'No Call Report';
      case 44:
        return 'Inactive Trailer Status Report';
      case 45:
        return 'Print Delivery Receipts';
      case 46:
        return 'Print Delivery Receipts in Batch';
      case 47:
        return 'Print Directions & Profiles';
      case 48:
        return 'Operations Reports Menu';
      case 49:
        return 'Customer Services Menu';
      case 50:
        return '';
      case 51:
        return 'Virtual Hours of Service 4.0';
      case 52:
        return 'Drvr&Load/Drop&Swap 2019 User Menu';
      case 53:
        return 'Special Driver Message Entry';
      case 54:
        return 'Sign Off';
      default:
        return '';
    }
  }
}  
Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'This menu is not active.',
        style: TextStyle(color: Colors.white, fontFamily: 'Courier', fontSize: 16),
        ),
      ),
    );
}


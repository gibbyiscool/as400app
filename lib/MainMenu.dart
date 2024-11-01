import 'package:as400app/AdminMenu.dart';
import 'package:as400app/DispatchMenu.dart';
import 'package:as400app/InactiveMenu.dart';
import 'DatabaseManagerAndCreators/TruckManager.dart';
import 'package:as400app/LogIn.dart';
import 'DatabaseManagerAndCreators/OrderManager.dart';
import 'package:flutter/material.dart';
import 'DatabaseManagerAndCreators/CustomerMana.dart';
import 'dart:async';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainMenu(),
      routes: {
        '/mainMenu': (context) => MainMenu(),
        '/dispatchServiceMenu': (context) => DispatchServiceMenu()
      },
    ));

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  String option = '';
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _updateTimeEveryMinute();
  }

  void _updateTimeEveryMinute() {
    timer = Timer.periodic(Duration(minutes: 1), (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    timer.cancel();
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
      case '1':
        Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerServicesMenu()));
        break;
      case '2':
        Navigator.push(context, MaterialPageRoute(builder: (context) => DispatchServiceMenu()));
        break;
      case '3':
      Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerLookupScreen()));
      case '4':
      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminMenuPage()));
      case '5':
      Navigator.push(context, MaterialPageRoute(builder: (context) => OrderCreatorScreen()));
      case '6':
       Navigator.push(context, MaterialPageRoute(builder: (context) => OrderLookupScreen()));
      case '7':
        Navigator.push(context, MaterialPageRoute(builder: (context) => TruckLookupScreen()));
        break;
      case '90':
        Navigator.push(context, MaterialPageRoute(builder: (context) => LogInView()));
        break;
      default:
        setState(() {
          option = '';
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
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
                          style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize/1.4),
                        ),
                        Text(
                          '${_getCurrentTime()}',
                          style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize/1.4),
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
                          style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: adjustedWidth * 0.43,
                          height: adjustedWidth / 25,
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
                          child: Text(
                            'MAIN MENU',
                            style: TextStyle(color: Colors.black, fontFamily: 'Courier New', fontSize: fontSize),
                          ),
                        ),
                        Text(
                          '©2003, 2024 Trimble Inc. All rights reserved.',
                          style: TextStyle(color: Colors.blue, fontFamily: 'Courier New', fontSize: fontSize / 1.2),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: adjustedWidth * 0.8,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          ...List.generate(
                            7,
                            (index) => Container(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${index + 1}. ',
                                      style: TextStyle(color: Colors.white, fontFamily: 'Courier', fontSize: fontSize),
                                    ),
                                    TextSpan(
                                      text: _getMenuOption(index + 1),
                                      style: TextStyle(color: const Color.fromARGB(255, 92, 216, 96), fontFamily: 'Courier', fontSize: fontSize),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '90. ',
                                    style: TextStyle(color: Colors.white, fontFamily: 'Courier', fontSize: fontSize),
                                  ),
                                  TextSpan(
                                    text: 'Sign Off',
                                    style: TextStyle(color: const Color.fromARGB(255, 92, 216, 96), fontFamily: 'Courier', fontSize: fontSize),
                                  ),
                                ],
                              ),
                            ),
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
                            maxLength: 2, // Limit input to 2 characters
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              isDense: true,
                              counterText: "",
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
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
    );
  }

  String _getMenuOption(int optionNumber) {
    switch (optionNumber) {
      case 1:
        return 'Customer Services Menu';
      case 2:
        return 'Dispatch Services Menu';
      case 3:
        return 'FlexEDI® Menu';
      case 4:
        return 'FlexFuel® Menu';
      case 5:
        return 'Master File Menu';
      case 6:
        return 'Network Management Menu';
      case 7:
        return 'DRVR&LOAD/DROP&SWAP 2022 User Menu';
      default:
        return '';
    }
  }
}

class CustomerServicesMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Services Menu'),
      ),
      body: Center(
        child: Text('Welcome to Customer Services Menu'),
      ),
    );
  }
}
class InactiveMenu extends StatelessWidget {
  @override
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
}

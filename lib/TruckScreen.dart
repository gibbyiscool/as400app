import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TruckScreen(),
      routes: {
        '/truckScreen': (context) => TruckScreen(),
      },
    ));

class TruckScreen extends StatefulWidget {
  @override
  _TruckScreenState createState() => _TruckScreenState();
}

class _TruckScreenState extends State<TruckScreen> {
  String tracNumber = '';
  String trlrNumber = '';
  String drv1Code = '';
  String drv2Code = '';
  String drv1Home = 'RDO';
  String drv2Home = 'RDO';
  String dmgr1 = 'VM#';
  String dmgr2 = 'VM#';
  String cust = '';
  String orig = '';
  String cmdty = '';
  String mileLoad = 'Empty';
  String trlrPalletBal = '';
  String cons = '';
  String cont = '00000000';
  String dest = '';
  String custNumber = '';
  String del = '';
  String currentOrderNumber = '00000000';
  String loc = '';
  String callType = '';
  String remark = '';
  String currentCallTime = '';
  String eta = '';
  String pta = '';
  List<Map<String, String>> previousCalls = [];
  
  late Timer timer;
  FocusNode _focusNode = FocusNode();

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

  void updatePreviousCalls(String loc, String type, String remark) {
    final currentTime = '${_getCurrentDate()} ${_getCurrentTime()}';
    setState(() {
      previousCalls.add({
        'Location': loc,
        'Type': type,
        'Remark': remark,
        'Time': currentTime,
        'Init': 'DNU'
      });
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
                            'Order #: $currentOrderNumber',
                            style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize / 1.4),
                          ),
                          Text(
                            '${_getCurrentDate()} ${_getCurrentTime()}',
                            style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize / 1.4),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 100,
                      left: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trac: _______   Trlr: _______   TRN: _______',
                            style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize),
                          ),
                          Text(
                            'Drv1: _______   Drv2: _______   Home: $drv1Home   Home: $drv2Home',
                            style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize),
                          ),
                          Text(
                            'Dmgr: $dmgr1   Dmgr: $dmgr2',
                            style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize),
                          ),
                          Text(
                            'Cust: _______   Cons: _______   Cont: $cont',
                            style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize),
                          ),
                          Text(
                            'Orig: _______   Dest: _______   Cust#: _______',
                            style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize),
                          ),
                          Text(
                            'Cmdty: _______   Trlr Plt Bal: _______',
                            style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize),
                          ),
                          Text(
                            'Mile Load: $mileLoad',
                            style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize),
                          ),
                          Text(
                            'NxtS Date/Time: ${_getCurrentDate()} ${_getCurrentTime()}   ETA: _______   PTA: _______',
                            style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 16.0,
                      left: 16.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Location:',
                            style: TextStyle(color: const Color.fromARGB(255, 92, 216, 96), fontFamily: 'Courier New', fontSize: fontSize),
                          ),
                          SizedBox(
                            width: adjustedWidth * 0.4,
                            child: TextField(
                              style: TextStyle(color: const Color.fromARGB(255, 92, 216, 96), fontFamily: 'Courier New', fontSize: fontSize),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 8),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  loc = value;
                                });
                              },
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
}

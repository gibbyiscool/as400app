import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; 
import 'package:as400app/UniversalTextInput.dart';
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
  String status = '';
  String drv1Code = '';
  String drv2Code = '';
  String drv1Home = '';
  String drv2Home = '';
  String dmgr1 = '';
  String dmgr2 = '';
  String custCode = '';
  String cust = '';
  String consCode = '';
  String cons = '';
  String origCityCode = '';
  String origCity = '';
  String destCityCode = '';
  String destCity = '';
  String cmdty = '';
  String mileLoad = '';
  String emptyMiles = '';
  String dhPercentage = '';
  String trlrPalletBal = '';
  String cont = '';
  String custNumber = '';
  String del = '';
  String puDateStart = '';
  String puTimeStart = '';
  String puDateEnd = '';
  String puTimeEnd = '';
  String delDateStart = '';
  String delTimeStart = '';
  String delDateEnd = '';
  String delTimeEnd = '';
  String eta = '';
  String pta = '';
  String errorMessage = '';
  bool changeBackground = false;
  bool isEditable = true;
  List<Map<String, String>> previousCalls = [];

  late Timer timer;
  FocusNode _focusNode = FocusNode();
  TextEditingController _tracNumberController = TextEditingController();
  TextEditingController _trlrNumberController = TextEditingController();
  TextEditingController _locController = TextEditingController();
  TextEditingController _typeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    _focusNode.requestFocus();
    _updateTimeEveryMinute();
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      print("App started - attempting to load truck 12345"); // Log: App started
      loadTruckData('12345'); // Automatically load truck data for '12345' on app start
    });*/
  }

  void _updateTimeEveryMinute() {
    timer = Timer.periodic(Duration(minutes: 1), (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    timer.cancel();
    _focusNode.dispose();
    _tracNumberController.dispose();
    _trlrNumberController.dispose();
    _locController.dispose();
    _typeController.dispose();
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

  Future<void> loadTruckData(String tracNumber) async {
    print('Loading truck data for $tracNumber');
    Database db = await openDatabase(join(await getDatabasesPath(), 'trucks.db'));
    List<Map<String, dynamic>> truckData = await db.query(
      'trucks',
      where: 'tracNumber = ?',
      whereArgs: [tracNumber],
    );
    print('query result for tracNumber $tracNumber: ${truckData.isNotEmpty ? truckData.first : 'No data found for $tracNumber'}');
    if (truckData.isNotEmpty) {
      setState(() {
        this.tracNumber = truckData.first['tracNumber'] ?? '';
        trlrNumber = truckData.first['trlrNumber'] ?? '';
        status = truckData.first['status'] ?? '';
        drv1Code = truckData.first['drv1Code'] ?? '';
        drv2Code = truckData.first['drv2Code'] ?? '';
        drv1Home = truckData.first['drv1Home'] ?? '';
        drv2Home = truckData.first['drv2Home'] ?? '';
        dmgr1 = truckData.first['dmgr1'] ?? '';
        dmgr2 = truckData.first['dmgr2'] ?? '';
        changeBackground = true;
        isEditable = false;
        
        _trlrNumberController.text = trlrNumber;
      });
      await loadOrderData(truckData.first['orderNumber'] ?? '');
    }
  }

  Future<void> loadOrderData(String orderNumber) async {
    if (orderNumber.isEmpty) return;
    Database db = await openDatabase(join(await getDatabasesPath(), 'orders.db'));
    List<Map<String, dynamic>> orderData = await db.query(
      'orders',
      where: 'currentOrderNumber = ?',
      whereArgs: [orderNumber],
    );
    if (orderData.isNotEmpty) {
      setState(() {
        custCode = orderData.first['custCode'] ?? '';
        consCode = orderData.first['consCode'] ?? '';
        cmdty = orderData.first['cmdty'] ?? '';
        mileLoad = orderData.first['mileLoad'] ?? '';
        trlrPalletBal = orderData.first['trlrPalletBal'] ?? '';
        cont = orderData.first['cont'] ?? '';
        puDateStart = orderData.first['puDateStart'] ?? '';
        puTimeStart = orderData.first['puTimeStart'] ?? '';
        puDateEnd = orderData.first['puDateEnd'] ?? '';
        puTimeEnd = orderData.first['puTimeEnd'] ?? '';
        delDateStart = orderData.first['delDateStart'] ?? '';
        delTimeStart = orderData.first['delTimeStart'] ?? '';
        delDateEnd = orderData.first['delDateEnd'] ?? '';
        delTimeEnd = orderData.first['delTimeEnd'] ?? '';
        eta = orderData.first['eta'] ?? '';
        pta = orderData.first['pta'] ?? '';
      });
      await loadCustomerData(consCode, isConsignee: true);
      await loadCustomerData(custCode, isConsignee: false);
    }
  }

  Future<void> loadCustomerData(String customerCode, {required bool isConsignee}) async {
    if (customerCode.isEmpty) return;
    Database db = await openDatabase(join(await getDatabasesPath(), 'customers.db'));
    List<Map<String, dynamic>> customerData = await db.query(
      'customers',
      where: 'customerCode = ?',
      whereArgs: [customerCode],
    );
    if (customerData.isNotEmpty) {
      setState(() {
        if (isConsignee) {
          cons = customerData.first['customerName'] ?? '';
          destCityCode = customerData.first['cityCode'] ?? '';
          destCity = customerData.first['city'] ?? '';
        } else {
          cust = customerData.first['customerName'] ?? '';
          origCityCode = customerData.first['cityCode'] ?? '';
          origCity = customerData.first['city'] ?? '';
          custNumber = customerData.first['customerCode'] ?? '';
        }
      });
    }
  }

  void _validateAndSubmitType() {
    String type = _typeController.text.trim().toUpperCase();
    if (type.isEmpty || !['C', 'E', 'L', 'D', 'T', 'F'].contains(type)) {
      setState(() {
        errorMessage = 'Please use a correct call method: C, E, L, D, T, F';
      });
    } else {
      setState(() {
        errorMessage = '';
      });
      // Proceed with further logic
    }
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
              double aspectRatio = 16 / 9;
              double width = constraints.maxWidth;
              double height = constraints.maxHeight;
              double adjustedWidth = width;
              double fontSize = adjustedWidth / 60;
              double characterWidth = fontSize * 0.6;
              double paddingSmall = width * 0.025;
              double paddingCust = width * 0.0209;
              double paddingCustTitle = width * 0.01;
              double cityPaddingTitle = width * 0.028;
              double paddingSmallTitle = width * 0.01;
              double paddingSmallEdge = width * 0.004;
              double cityPadding = width * 0.02;  // For minimal spacing
              double timeDatePadding = width * 0.050;
              double timeDatePaddingSpacer = width * 0.0642;
              double timeDatePaddingTitle = width * 0.09;
              double timeDatePaddingTitleSpacer = width * 0.08;
              double trlrPadding = width * 0.01;
              double locPadding = width * 0.01;
              
              return Container(
                width: adjustedWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Row(
                        children: [
                            Padding(
                              padding: EdgeInsets.only(right: trlrPadding), 
                              child: Row(
                              children: [
                                Text('Trac: ', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize)),
                              SizedBox(
                                width: width*0.055,
                        
                                child: UniversalTextInput(
                                  label: '',
                                  maxLength: 5,
                                  controller: _tracNumberController,
                                  fillWithZeros: false,
                                  showCursor: true,
                                  isEditable: isEditable,
                                  fontSize: fontSize,
                                  changeBackground: changeBackground,
                                  characterWidth: characterWidth,
                                  onSubmit: (value) {
                                    changeBackground = true;
                                    loadTruckData(value);
                                  },
                                ),
                              ),
                            ],                            
                            ),
                            ),
                          Padding(
                              padding: EdgeInsets.only(right: locPadding), 
                              child: Row(
                              children: [
                                Text('trlr: ', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize)),
                              SizedBox(
                                width: width*0.06,
                        
                                child: UniversalTextInput(
                                  label: '',
                                  maxLength: 6,
                                  controller: _trlrNumberController,
                                  fillWithZeros: false,
                                  showCursor: true,
                                  isEditable: isEditable,
                                  fontSize: fontSize,
                                  changeBackground: false,
                                  characterWidth: characterWidth,
                                  onSubmit: (value) {
                                    changeBackground = true;
                                    loadTruckData(value);
                                  },
                                ),
                              ),
                            ],                            
                            ),
                            ),
                          Padding(
                              padding: EdgeInsets.only(right: trlrPadding), 
                              child: Row(
                              children: [
                                Text('loc: ', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize)),
                              SizedBox(
                                width: width*0.06,
                        
                                child: UniversalTextInput(
                                  label: '',
                                  maxLength: 6,
                                  controller: _locController,
                                  fillWithZeros: false,
                                  showCursor: true,
                                  isEditable: true,
                                  fontSize: fontSize,
                                  changeBackground: false,
                                  characterWidth: characterWidth,
                                  onSubmit: (value) {
                                    changeBackground = true;
                                    loadTruckData(value);
                                  },
                                ),
                              ),
                            ],                            
                            ),
                            ),
                          SizedBox(width: 16),
                          Text('Type: ', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize)),
                          SizedBox(
                            width: 25,
                            child: TextField(
                              controller: _typeController,
                              maxLength: 1,
                              style: TextStyle(color: Colors.yellow, fontFamily: 'Courier New', fontSize: fontSize),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                counterText: '',
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                              ),
                              onSubmitted: (value) {
                                _validateAndSubmitType();
                              },
                            ),
                          ),
                          Text('Status: $status', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize)),

                        ],
                      ),
                    ),
                    if (errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          errorMessage,
                          style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize),
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Drv1: $drv1Code', style: TextStyle(color: Colors.yellow, fontFamily: 'Courier New', fontSize: fontSize)),
                              
                              SizedBox(height: 1),
                              Text('Home: $drv1Home', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
                              SizedBox(height: 1),
                              Text('Dmgr: $dmgr1', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
                              SizedBox(height: 1),
                              Text('Cust: $custCode $cust', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
                              SizedBox(height: 1),
                              Text('Cont: $cont', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
                              SizedBox(height: 1),
                              Text('Orig: $origCityCode $origCity', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
                              SizedBox(height: 1),
                              Text('Cmdty: $cmdty   Trlr Plt Bal: $trlrPalletBal', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize)),
                              SizedBox(height: 1),
                              Text('Mile Load: $mileLoad   Empty: $emptyMiles   DH%: $dhPercentage', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize)),
                              SizedBox(height: 1),
                              Text('NxtS: $origCityCode', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
                              SizedBox(height: 1),
                            ],
                          ),
                        ),
                        
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Drv2: $drv2Code', softWrap: false, style: TextStyle(color: Colors.yellow, fontFamily: 'Courier New', fontSize: fontSize)),
                              SizedBox(height: 1),
                              Text('Home: $drv2Home', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
                              SizedBox(height: 1),
                              Text('Dmgr: $dmgr2', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
                              SizedBox(height: 1),
                              Text('Cons: $consCode $cons', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
                              SizedBox(height: 1),
                              Text('Cont: N/A', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
                              SizedBox(height: 1),
                              Text('Dest: $destCityCode $destCity', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
                              SizedBox(height: 1),
                              Text('Cust#: $custNumber', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
                              SizedBox(height: 1),
                              Text('Del: N/A', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
                              SizedBox(height: 1),
                              Text('ETA: $eta   PTA: $pta', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
                              SizedBox(height: 1),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
Row(
children: [
          // Stp and Typ very close to each other
          Padding(
            padding: EdgeInsets.only(right: paddingSmallTitle), // Minimal spacing for 'Stp'
            child: Text('Stp', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize)),
          ),
          Padding(
            padding: EdgeInsets.only(right: paddingCustTitle), // Slightly more space after 'Typ'
            child: Text('Typ', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize)),
          ),

          // Cust and City close to Typ and each other
          Padding(
            padding: EdgeInsets.only(right: cityPaddingTitle), // Moderate spacing for 'Cust'
            child: Text('Cust', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize)),
          ),
          Padding(
            padding: EdgeInsets.only(right: timeDatePaddingTitleSpacer), // Spacing for 'City'
            child: Text('City', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize)),
          ),

          // Scheduled, ETA, Arrived, Departure far from each other
          Padding(
            padding: EdgeInsets.only(right: timeDatePaddingTitle), // Extra spacing between items
            child: Text('Scheduled', softWrap: false, style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize)),
          ),
          Padding(
            padding: EdgeInsets.only(right: timeDatePaddingTitle * 1.08),
            child: Text('ETA', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize)),
          ),
          Padding(
            padding: EdgeInsets.only(right: timeDatePaddingTitle),
            child: Text('Arrived', softWrap: false, style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize)),
          ),
          Text('Departure', softWrap: false, style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize)),
        ],
),

                    Row(
  children: [
          // 01 and P very close to each other
          Padding(
            padding: EdgeInsets.only(right: paddingSmall, left: paddingSmallEdge), // Minimal spacing for '01'
            child: Text('01', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
          ),
          Padding(
            padding: EdgeInsets.only(right: paddingCust),
            child: Text('P', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
          ),

          // custCode and origCity close to each other and to P
          Padding(
            padding: EdgeInsets.only(right: cityPadding),
            child: Text('$custCode', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
          ),
          Padding(
            padding: EdgeInsets.only(right: timeDatePaddingSpacer),
            child: Text('$origCityCode', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
          ),

          // Scheduled, ETA, Arrived, Departure far from each other
          Padding(
            padding: EdgeInsets.only(right: timeDatePadding),
            child: Text('$puDateStart  $puTimeStart', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
          ),
          Padding(
            padding: EdgeInsets.only(right: timeDatePadding * 1 ), // Increase spacing for these items
            child: Text('$puDateEnd  $puTimeEnd', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
          ),
          // Arrival times and Departure times (00 values)
          Padding(
            padding: EdgeInsets.only(right: timeDatePadding * 1.6),
            child: Text('0000 0000', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
          ),
          Text('0000 0000', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
        ],
),

                    Row(
                      children: [
          // 90 and D very close to each other
          Padding(
            padding: EdgeInsets.only(right: paddingSmall, left: paddingSmallEdge), // Minimal spacing for '90'
            child: Text('90', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
          ),
          Padding(
            padding: EdgeInsets.only(right: paddingCust),
            child: Text('D', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
          ),

          // consCode and destCityCode close to each other and to 'D'
          Padding(
            padding: EdgeInsets.only(right: cityPadding),
            child: Text('$consCode', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
          ),
          Padding(
            padding: EdgeInsets.only(right: timeDatePaddingSpacer),
            child: Text('$destCityCode', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
          ),

          // delDateStart, delTimeStart, delDateEnd, delTimeEnd far from each other
          Padding(
            padding: EdgeInsets.only(right: timeDatePadding), // Spacing for delivery start time
            child: Text('$delDateStart  $delTimeStart', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
          ),
          Padding(
            padding: EdgeInsets.only(right: timeDatePadding), // Spacing for delivery end time
            child: Text('$delDateEnd  $delTimeEnd', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
          ),

          // Arrival times and Departure times (00 values)
          Padding(
            padding: EdgeInsets.only(right: timeDatePadding * 1.6), // Increased spacing for these items
            child: Text('0000 0000', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
          ),
          Text('0000 0000', style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
        ],
                    ),
                    SizedBox(height: 12),
                    Text('SAT Info Lst Loc N/A       N/A TM ${_getCurrentTime()} MPH N/A To Dst: MPH N/A Mls 0000', softWrap: false,  style: TextStyle(color: Colors.white, fontFamily: 'Courier New', fontSize: fontSize)),
                    
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: Text('Date', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                        Expanded(child: Text('Time', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                        Expanded(child: Text('Cust', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                        Expanded(child: Text('Location', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                        Expanded(child: Text('Remarks', softWrap: false, style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                        Expanded(child: Text('Init', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: Text('Filler', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                        Expanded(child: Text('Filler', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                        Expanded(child: Text('Filler', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                        Expanded(child: Text('Filler', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                        Expanded(child: Text('Filler', softWrap: false, style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                        Expanded(child: Text('Filler', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text('Filler', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                        Expanded(child: Text('Filler', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                        Expanded(child: Text('Filler', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                        Expanded(child: Text('Filler', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                        Expanded(child: Text('Filler', softWrap: false, style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                        Expanded(child: Text('Filler', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text('Filler', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                        Expanded(child: Text('Filler', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                        Expanded(child: Text('Filler', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                        Expanded(child: Text('Filler', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                        Expanded(child: Text('Filler', softWrap: false, style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                        Expanded(child: Text('Filler', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize))),
                      ],
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universal Text Input Adaptation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SampleTextInputScreen(),
    );
  }
}

class SampleTextInputScreen extends StatefulWidget {
  @override
  _SampleTextInputScreenState createState() => _SampleTextInputScreenState();
}

class _SampleTextInputScreenState extends State<SampleTextInputScreen> {
  final TextEditingController _sampleController = TextEditingController();
  final TextEditingController _tracNumberController = TextEditingController();
  String tracNumber = '';
  String trlrNumber = '';
  String status = '';
  String drv1Code = '';
  String drv2Code = '';
  String drv1Home = '';
  String drv2Home = '';
  String dmgr1 = '';
  String dmgr2 = '';
  bool changeBackground = false;
  bool isSampleEditable = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Sample Text Input'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            double fontSize = width / 40;
            double characterWidth = fontSize * 0.6;

            return Container(
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UniversalTextInput(
                          label: 'Sample:',
                          maxLength: 7,
                          controller: _sampleController,
                          fillWithZeros: true,
                          showCursor: true,
                          fontSize: fontSize,
                          characterWidth: characterWidth,
                          changeBackground: changeBackground,
                          isEditable: isSampleEditable,
                          onSubmit: (value) {
                            print('Submitted Sample value: $value');
                          },
                        ),
                        SizedBox(height: 16),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Trac: ', style: TextStyle(color: Colors.green, fontFamily: 'Courier New', fontSize: fontSize)),
                              SizedBox(
                                width: width * 0.3,
                                child: UniversalTextInput(
                                  label: '',
                                  maxLength: 5,
                                  controller: _tracNumberController,
                                  fillWithZeros: false,
                                  showCursor: true,
                                  fontSize: fontSize,
                                  characterWidth: characterWidth,
                                  changeBackground: changeBackground,
                                  isEditable: true,
                                  onSubmit: (value) {
                                    loadTruckData(value);
                                  },
                                ),
                              ),
                            ],
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

  Future<void> loadTruckData(String tracNumber) async {
    databaseFactory = databaseFactoryFfi;
    print('Attempting to load truck data for tracNumber: $tracNumber');
    Database db = await openDatabase(join(await getDatabasesPath(), 'trucks.db'));
    List<Map<String, dynamic>> truckData = await db.query(
      'trucks',
      where: 'tracNumber = ?',
      whereArgs: [tracNumber],
    );
    if (truckData.isNotEmpty) {
      print('Truck data retrieved: $truckData');
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
        isSampleEditable = false;
        _sampleController.text = trlrNumber; // Autofill the sample input with trailer number
      });
      print('Truck data loaded successfully: Trac: $tracNumber, Trlr: $trlrNumber, Status: $status, Drv1: $drv1Code, Drv2: $drv2Code, Dmgr1: $dmgr1, Dmgr2: $dmgr2');
      await loadOrderData(truckData.first['orderNumber'] ?? '');
    } else {
      print('No truck data found for tracNumber: $tracNumber');
    }
  }

  Future<void> loadOrderData(String orderNumber) async {
    // Logic for loading order data
  }
}

class UniversalTextInput extends StatefulWidget {
  final String label;
  final int maxLength;
  final TextEditingController controller;
  final bool fillWithZeros;
  final bool showCursor;
  final double fontSize;
  final double characterWidth;
  final bool changeBackground;
  final bool isEditable;
  final Function(String) onSubmit;

  const UniversalTextInput({
    required this.label,
    required this.maxLength,
    required this.controller,
    required this.fillWithZeros,
    this.showCursor = false,
    required this.fontSize,
    required this.characterWidth,
    required this.changeBackground,
    required this.isEditable,
    required this.onSubmit,
    Key? key,
  }) : super(key: key);

  @override
  _UniversalTextInputState createState() => _UniversalTextInputState();
}

class _UniversalTextInputState extends State<UniversalTextInput> {
  int cursorPosition = 0;
  bool isFocused = false;

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.fillWithZeros
        ? '0' * widget.maxLength
        : '';

    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
        print('Focus changed: isFocused = $isFocused');
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }


    KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    print('Key event: $event');
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace && cursorPosition > 0) {
        setState(() {
          cursorPosition--;
          final text = widget.controller.text;
          widget.controller.text = text.replaceRange(cursorPosition, cursorPosition + 1 > text.length ? text.length : cursorPosition + 1, '0');
          widget.controller.selection = TextSelection.collapsed(offset: cursorPosition);
          print('Backspace pressed: cursorPosition = $cursorPosition, text = ${widget.controller.text}');
        });
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft && cursorPosition > 0) {
        setState(() {
          cursorPosition--;
          widget.controller.selection = TextSelection.collapsed(offset: cursorPosition);
          print('Arrow left pressed: cursorPosition = $cursorPosition');
        });
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight && cursorPosition < widget.maxLength) {
        setState(() {
          cursorPosition++;
          widget.controller.selection = TextSelection.collapsed(offset: cursorPosition);
          print('Arrow right pressed: cursorPosition = $cursorPosition');
        });
        return KeyEventResult.handled;
      } else if (event.character != null &&
          event.character!.length == 1 &&
          RegExp(r'[a-zA-Z0-9]').hasMatch(event.character!)) {
        setState(() {
          final text = widget.controller.text;
          widget.controller.text = text.replaceRange(cursorPosition, cursorPosition + 1 > text.length ? text.length : cursorPosition + 1, event.character!);
          if (cursorPosition < widget.maxLength - 1) {
            cursorPosition++;
          }
          widget.controller.selection = TextSelection.collapsed(offset: cursorPosition);
          print('Character input: cursorPosition = $cursorPosition, text = ${widget.controller.text}');
        });
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    print('Build called: cursorPosition = $cursorPosition, text = ${widget.controller.text}, isFocused = $isFocused');
    return GestureDetector(
      onTap: () {
        if (!_focusNode.hasFocus && widget.isEditable) {
          FocusScope.of(context).requestFocus(_focusNode);
        }
      },
      child: Focus(
        focusNode: _focusNode,
        onKeyEvent: (node, event) => _handleKeyEvent(node, event),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              width: widget.characterWidth * widget.maxLength, // Adjust container width to fit text
              height: widget.fontSize * 1.6, // Adjust height to make the box smaller and align text properly
              color: widget.changeBackground ? const Color.fromARGB(255, 0, 255, 0) : Colors.transparent,
              //padding: EdgeInsets.only(bottom: 1),
              child: Align(
                alignment: Alignment.topCenter,
                child: TextField(
                  controller: widget.controller,
                  enabled: widget.isEditable,
                  showCursor: false,
                  maxLength: widget.maxLength,
                  style: TextStyle(
                    color: widget.changeBackground ? Colors.black : Colors.white,
                    fontSize: widget.fontSize,
                    fontFamily: 'Courier',
                    height: 1.0, // Adjust line height to properly align text vertically
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 18), // Adjust padding to align text properly
                    
                  ),
                  onSubmitted: (value) {
                    widget.onSubmit(value);
                  },
                ),
              ),
            ),
            if (widget.showCursor && isFocused)
              Positioned(
                left: cursorPosition * widget.characterWidth, // Adjust to match the width of character
                bottom: 0,
                child: Container(
                  width: widget.characterWidth, // Adjust to match the width of character
                  height: 3,
                  color: Colors.white,
                ),
              ),
            for (int i = 0; i < widget.maxLength; i++)
              Positioned(
                left: i * widget.characterWidth,
                bottom: 0,
                child: Container(
                  width: 1,
                  height: 4,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

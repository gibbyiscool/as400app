import 'package:as400app/DispatchMenu.dart';
import 'package:as400app/InactiveMenu.dart';
import 'package:as400app/MainMenu.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class LogInView extends StatefulWidget {
  @override
  _LogInViewState createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  String username = '';
  String password = '';
  String? errorMessage;

  final Map<String, String> users = {
    'Admin': 'password',
    'Test': '1234',
    'Testing': 'Western1',
    'NewUser': 'Western1',
  };

  void handleLogin() {
    if (authenticateUser(username, password)) {
      if (username == 'Admin') {
        Navigator.pushNamed(context, '/adminPage');
      } else {
        Navigator.pushNamed(context, '/mainMenu');
      }
    } else {
      setState(() {
        errorMessage = 'Incorrect username or password';
      });
    }
  }

  bool authenticateUser(String username, String password) {
    if (users.containsKey(username)) {
      return users[username] == password;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double aspectRatio = 4 / 3;
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          double adjustedWidth = width < height * aspectRatio ? width : height * aspectRatio;
          double fontSize = adjustedWidth / 50;
          double boxWidth = adjustedWidth;
          double boxHeight = adjustedWidth / aspectRatio;

          return Stack(
            children: [
              Container(color: Colors.black),
              Center(
                child: SizedBox(
                  width: boxWidth,
                  height: boxHeight,
                  child: Stack(
                    children: [
                      Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            fullTruckAsciiArt(),
                            style: TextStyle(
                              fontFamily: 'Courier',
                              fontSize: fontSize,
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Positioned(
                        top: boxHeight * 0.3,
                        left: boxWidth * 0.45,
                        child: SizedBox(
                          width: boxWidth * 0.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'WELCOME TO WESTERN EXPRESS INC.',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontFamily: 'Courier',
                                  fontSize: fontSize,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final Uri url = Uri.parse('http://www.westernexp.com');
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Could not launch $url')),
                                    );
                                  }
                                },
                                child: Text(
                                  'www.westernexp.com',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontFamily: 'Courier',
                                    fontSize: fontSize,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2.0,
                                  ),
                                ),
                              ),
                              SizedBox(height: boxHeight * 0.01),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'User ------',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontFamily: 'Courier',
                                      fontSize: fontSize,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  SizedBox(
                                    width: boxWidth * 0.15,
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          username = value;
                                          errorMessage = null;
                                        });
                                      },
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontFamily: 'Courier',
                                        fontSize: fontSize,
                                      ),
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
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: boxHeight * 0.01),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Password --',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontFamily: 'Courier',
                                      fontSize: fontSize,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  SizedBox(
                                    width: boxWidth * 0.15,
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          password = value;
                                          errorMessage = null;
                                        });
                                      },
                                      obscureText: true,
                                      style: TextStyle(
                                        color: const Color.fromARGB(0, 0, 0, 0),
                                        fontFamily: 'Courier',
                                        fontSize: fontSize,
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                                        filled: true,
                                        fillColor: Colors.transparent,
                                        border: InputBorder.none,
                                      ),
                                      onSubmitted: (value) => handleLogin(),
                                    ),
                                  ),
                                ],
                              ),
                              if (errorMessage != null)
                                Padding(
                                  padding: EdgeInsets.only(top: boxHeight * 0.02),
                                  child: Text(
                                    errorMessage!,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontFamily: 'Courier',
                                      fontSize: fontSize,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String fullTruckAsciiArt() {
    return '''
                                         O   
                                        O    ____________________________________________
                                       | |  |
                         ____________  | |  |
                         / _________ | | |  |
                        / /        | | | |  |
                       / /         | | | |  |
                      / /          | | | |  |
    _________________/ /___________| | | |  |      
    |                  |  Western  | | | |  |
    |                  '  Express  | | | |  |
    |                  |           | | | |  |
    |    _______       '  DRIVE    | | | |  |
|   | |-/       \\      |    SAFE!  | | | |  |____________________________________________
|   |  /  O O O  \\     |___________| | | | _________/_/__  O O O   O O O __|   |  /    
|   |_/  O     O  \\__________________| | | _____________  O     O O     O |    | /
         O  O  O    |                       |             O  O  O O  O  O |    |/
         O     O    |_______________________|             O     O O     O |    |
          O O O                                            O O O   O O O       -
''';
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LogInView(),
        '/mainMenu': (context) => MainMenu(),
        '/adminPage': (context) => AdminPage(),
        '/customerServices': (context) => CustomerServicesMenu(),
        '/dispatchServiceMenu': (context) => DispatchServiceMenu(),
        //'/inactiveMenu': (context) => InactiveMenu(),
      },
    );
  }
}

class GlobalKeyListener extends StatefulWidget {
  final Widget child;

  GlobalKeyListener({required this.child});

  @override
  _GlobalKeyListenerState createState() => _GlobalKeyListenerState();
}

class _GlobalKeyListenerState extends State<GlobalKeyListener> {
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.f3 &&
              Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          // Add more global key bindings here as needed
        }
      },
      child: widget.child,
    );
  }
}

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page WIP!!!!'),
      ),
      body: Center(
        child: Text('Welcome, Admin! WIP!!!!'),
      ),
    );
  }
}

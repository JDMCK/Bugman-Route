import 'package:bugman_route/helper/sheetsAPI.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bugman_route/helper/authenticator.dart';

class AuthLoad extends StatefulWidget {
  const AuthLoad({Key? key}) : super(key: key);

  @override
  State<AuthLoad> createState() => _AuthLoadState();
}

class _AuthLoadState extends State<AuthLoad> {
  // JSON authorization
  final Authenticator auth = Authenticator();

  // Text Field
  bool doPinInput = false;
  bool incorrectPin = false;

  // Loads routes and tech name from pin
  void loadRoutes(String pin) async {
    User user = await SheetsAPI.getUserByPin(pin);
    if (user.pin == null) {
      doPinInput = true;
      auth.getCorrectPins();
      pinInput('Reset occurred');
    } else {
      Navigator.popAndPushNamed(context, '/home', arguments: user);
    }
  }

  // Handles pin input
  void pinInput(String pin) async {
    if (await auth.isGoodPin(pin)) {
      setState(() {
        doPinInput = false;
        incorrectPin = false;
      });
      auth.newEntryEvent(pin);
      loadRoutes(pin);
    } else {
      setState(() {
        incorrectPin = true;
      });
    }
  }

  // Initially shows input box if authenticate is false
  void initInput() async {
    AuthResponse response = await auth.authenticate();
    if (response.isAuthenticated) {
      loadRoutes(response.pin);
    } else {
      setState(() {
        doPinInput = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initInput();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FractionallySizedBox(
              widthFactor: 0.75,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset('assets/images/bugman_logo_full.png'),
              ),
            ),
            if (doPinInput)
              FractionallySizedBox(
                widthFactor: 0.6,
                child: TextField(
                  onChanged: (pin) {
                    if (pin.length == 6)
                      pinInput(pin);
                  },
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  //textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, letterSpacing: 20),
                  obscureText: true,
                  //obscuringCharacter: '*',
                  autofocus: true,
                  decoration: InputDecoration(
                    //hintStyle: TextStyle(
                        //fontSize: 20, color: Colors.grey, letterSpacing: 1),
                    hintText: "PIN",
                    filled: true,
                    //fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            if (incorrectPin)
              Text(
                'Incorrect PIN',
                style: TextStyle(color: Colors.red),
              )
          ],
        ),
      ),
    );
  }
}

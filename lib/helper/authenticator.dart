import 'package:path_provider/path_provider.dart';
import 'package:bugman_route/helper/sheetsAPI.dart';
import 'dart:io';
import 'dart:convert';

class Authenticator {
  // Dealing with JSON
  final String defaultPin = '000000';
  final String defaultTime = '0';
  //final int authRefreshHours = 24;
  File? authFile;

  // Dealing with PIN stuff
  String? attemptedPin;
  List<String>? correctPins;

  // Returns file object auth.JSON
  Future<void> getFile() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String? authDirectoryPath = directory.path;
      authFile = File('$authDirectoryPath/auth.JSON');
    } catch (e) {
      throw Exception('Failed to get file path');
    }
  }

  // Initializes JSON file
  void authInit(File authFile) {
    try {
      authFile
          .writeAsString('{"pin": "$defaultPin", "timeStamp": "$defaultTime"}');
    } catch (e) {
      throw Exception('Failed to initialize file');
    }
  }

  // Returns JSON file
  dynamic readJSON(File authFile) async {
    try {
      String rawJSON = await authFile.readAsString();
      return jsonDecode(rawJSON);
    } catch (e) {
      throw Exception('Failed to read JSON/Invalid JSON');
    }
  }

  // Inspects JSON file for latest entry and/or good pin (time/pin)
  Future<bool> isGoodJSON(dynamic json) async {
      // DateTime timeAccessed =
      //     DateTime.fromMillisecondsSinceEpoch(int.parse(json['timeStamp']));
      // int timeDifference = DateTime.now().difference(timeAccessed).inHours;
      // if (timeDifference < authRefreshHours) {
      //   return true;
      // }
    // Send current pin to server and await a true or false call
    String currentPin = json['pin'];
    return isGoodPin(currentPin);
  }

  // Determines if the pin matches to the one set in the server
  Future<bool> isGoodPin(String pin) async {
    if (correctPins != null && correctPins!.contains(pin)) {
      return true;
    }
    return false;
  }

  // Writes to auth file new time of entry
  void newEntryEvent(String pin) {
    try {
      int nowTime = DateTime.now().millisecondsSinceEpoch;
      authFile!.writeAsString('{"pin": "$pin", "timeStamp": "$nowTime"}');
    } catch (e) {
      throw Exception('Failed to write to file');
    }
  }

  // Gets correct pins from userSheet
  Future<List<String>?> getCorrectPins() async {
    correctPins = await SheetsAPI.getPins();
    return correctPins;
  }

  // Authenticates user
  Future<AuthResponse> authenticate({bool reset = false}) async {
    await getFile();
    if (authFile!.existsSync() == false || reset) {
      authInit(authFile!);
    }
    dynamic authJSON = await readJSON(authFile!);
    await getCorrectPins();
    // Write to file
    if (await isGoodJSON(authJSON)) {
      String pin = authJSON['pin'].toString();
      newEntryEvent(pin);
      return AuthResponse(pin: pin, isAuthenticated: true);
    }
    return AuthResponse();
  }
}

class AuthResponse {
  String pin;
  bool isAuthenticated;

  AuthResponse({this.pin = "000000", this.isAuthenticated = false});
}

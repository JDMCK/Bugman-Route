import 'package:gsheets/gsheets.dart';

class SheetsAPI {
  static const String credentials = r'''
{
  SECRETS_HERE
}
''';
  static const String spreadsheetId = 'SECRET';
  static final GSheets gsheets = GSheets(credentials);
  static Worksheet? userSheet;
  static Worksheet? pmSheet;
  static Worksheet? routeSheet;
  static Worksheet? pmServiceSheet;
  static Worksheet? testSheet;

  static Future<Worksheet> getWorkSheet(Spreadsheet spreadsheet, {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future init({String workSheet = 'main'}) async {
    final spreadsheet = await gsheets.spreadsheet(spreadsheetId);
    userSheet = await getWorkSheet(spreadsheet, title: 'Users');
    pmSheet = await getWorkSheet(spreadsheet, title: 'PMs');
  }

  static Future<List<String>?> getPins() async {
    if (userSheet != null) {
      return userSheet!.values.columnByKey('pin');
    }
  }

  static Future<User> getUserByPin(String pin) async {
    List<String>? userList = await userSheet!.values.rowByKey(pin, fromColumn: 1, length: 4);
    if (userList != null){
      List<PM>? route = await getRouteById(id: userList[3]);
      return User(pin: userList[0], firstName: userList[1], lastName: userList[2], route: route);
    }
    return User();
  }

  static Future<List<PM>?> getRouteById({required String id}) async {
    // Get all routeIDs from client sheet
    List<String>? routeIds = await pmSheet!.values.columnByKey('route');
    // Converts list to map with indices as keys
    Map<int, String> idMap = Map.from(routeIds!.asMap());
    // Strips away all non relevant routeID's
    idMap.removeWhere((key, value) => value != id); // <- ERROR
    // Gets client data from each index
    List<PM> route = [];
    for(int key in idMap.keys) {
      List<dynamic> pmList = await pmSheet!.values.row(key+2);
      PM pm = PM(pmList);
      route.add(pm);
    }
    return route;
  }

  static Future<void> servicePM({required pmID, required servicer, required serviceDate, required psnReplaced}) async {
    int row = await pmSheet!.values.rowIndexOf(pmID);
    int column = await pmSheet!.values.columnIndexOf('servicerId');
    await pmSheet!.values.insertValue(servicer, column: column, row: row);
    await pmSheet!.values.insertValue(serviceDate, column: column+1, row: row);
    await pmSheet!.values.insertValue(psnReplaced, column: column+2, row: row);
  }
}

class User {
  String? pin;
  String? firstName;
  String? lastName;
  List<PM>? route;

  User({this.pin, this.firstName, this.lastName, this.route});

  List<dynamic> getList() {
    return [pin, firstName, lastName, route];
  }
}

class PM {
  String? pmId;
  String? firstName;
  String? lastName;
  String? address;
  String? phone;
  String? tenantFirst;
  String? tenantLast;
  int? baitStns = 0;
  String? mapLink;
  String? report = 'False';
  String? fifteenHU;
  String? twentyfourHU;
  double? price = 0;
  String? poison;
  String? servicerId;
  String? serviceDate;
  String? psnReplaced;
  String? routeId;

  PM(List<dynamic> attributes) {
    if (attributes.length == 18) {
      this.pmId = attributes[0];
      this.firstName = attributes[1];
      this.lastName = attributes[2];
      this.address = attributes[3];
      this.phone = attributes[4];
      this.tenantFirst = attributes[5];
      this.tenantLast = attributes[6];
      if (attributes[7] != '') {this.baitStns = int.parse(attributes[7]);}
      this.mapLink = attributes[8];
      if (attributes[9] != '') {this.report = 'True';}
      this.fifteenHU = attributes[10];
      this.twentyfourHU = attributes[11];
      if (attributes[12] != '') {this.price = double.parse(attributes[12]);}
      this.poison = attributes[13];
      this.servicerId = attributes[14];
      this.serviceDate = attributes[15];
      this.psnReplaced = attributes[16];
      this.routeId = attributes[17];
    }
  }
}

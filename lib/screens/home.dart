import 'package:flutter/material.dart';
import 'package:bugman_route/helper/authenticator.dart';
import 'package:bugman_route/helper/sheetsAPI.dart';
import 'package:bugman_route/helper/PMCard.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? userID;

  void menuSelect(String choice) async {
    if (choice == 'Sign out') {
      Authenticator auth = Authenticator();
      auth.authenticate(reset: true);
    }
    Navigator.popAndPushNamed(context, '/');
  }

  void pmSelect(PM pm) async {
    await Navigator.pushNamed(context, '/pmScreen', arguments: pm);
    setState(() {});
    await SheetsAPI.servicePM(
        pmID: pm.pmId,
        servicer: pm.serviceDate != '' ? userID : '',
        serviceDate: pm.serviceDate,
        psnReplaced: pm.serviceDate != '' ? pm.psnReplaced : '');
  }

  @override
  Widget build(BuildContext context) {
    User user = ModalRoute.of(context)?.settings.arguments as User;
    userID = user.pin;

    return Scaffold(
        appBar: AppBar(
          title: Text("${user.firstName}'s Route"),
          actions: [
            PopupMenuButton(
              onSelected: menuSelect,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'Reload',
                  child: Text('Reload'),
                ),
                PopupMenuItem(
                  value: 'Sign out',
                  child: Text('Sign out'),
                ),
              ],
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
          child: ListView(
              children: user.route!
                  .map((pm) => PMCard(
                        pm: pm,
                        pmSelect: pmSelect,
                      ))
                  .toList()),
        ));
  }
}

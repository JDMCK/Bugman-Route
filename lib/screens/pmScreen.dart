import 'package:flutter/material.dart';
import 'package:bugman_route/helper/sheetsAPI.dart';
import 'package:url_launcher/url_launcher.dart';

class PMScreen extends StatefulWidget {
  const PMScreen({Key? key}) : super(key: key);

  @override
  State<PMScreen> createState() => _PMScreenState();
}

class _PMScreenState extends State<PMScreen> {
  @override
  Widget build(BuildContext context) {
    PM pm = ModalRoute.of(context)?.settings.arguments as PM;
    String psnReplaced = '';

    void completePM() {
      Navigator.pop(context);
      pm.serviceDate = '${DateTime.now().month}-${DateTime.now().day}';
      pm.psnReplaced = psnReplaced;
      Navigator.pop(context, pm);
    }

    void reopenPM() {
      pm.servicerId = '';
      pm.serviceDate = '';
      pm.psnReplaced = '';
      Navigator.pop(context, pm);
    }

    Widget divider = const Divider(
      thickness: 1.5,
      indent: 15,
      endIndent: 15,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${pm.firstName} ${pm.lastName}'),
        automaticallyImplyLeading: true,
      ),
      body: Theme(
        data: ThemeData(
            textTheme: Theme.of(context).textTheme.apply(fontSizeFactor: 1.3)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: ListView(
            children: [
              if (pm.tenantFirst != '' || pm.tenantLast != '')
                ListTile(
                  title: Text('${pm.tenantFirst} ${pm.tenantLast}'),
                  subtitle: Text('Tenant Name'),
                ),
              if (pm.tenantFirst != '' || pm.tenantLast != '') divider,
              if (pm.address != '')
                ListTile(
                  title: Text('${pm.address}'),
                  subtitle: Text('Address'),
                ),
              if (pm.address != '') divider,
              ListTile(
                title: Text('${pm.baitStns}'),
                subtitle: Text('Bait Station(s)'),
              ),
              divider,
              ListTile(
                title: InkWell(
                  child: Text(
                    'Click Me',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: (() async {
                    Uri url = Uri.parse(pm.mapLink!);
                    await launchUrl(url);
                    //if (await canLaunchUrl(url)) {
                    //  await launchUrl(url);
                    //}
                  }),
                ),
                subtitle: Text('Jobber Link'),
              ),
              if (pm.address != '') divider,
              ListTile(
                title: Text('${pm.poison}'),
                subtitle: Text('Poison'),
              ),
              divider,
              if (pm.fifteenHU != '')
                ListTile(
                  title: Text('${pm.fifteenHU}'),
                  subtitle: Text('15 min Heads Up'),
                ),
              if (pm.fifteenHU != '') divider,
              if (pm.twentyfourHU != '')
                ListTile(
                  title: Text('${pm.twentyfourHU}'),
                  subtitle: Text('24 hr Heads up'),
                ),
              if (pm.twentyfourHU != '') divider,
              if (pm.phone != '')
                ListTile(
                  title: Text('${pm.phone}'),
                  subtitle: Text('Phone #'),
                ),
              if (pm.phone != '') divider,
              ListTile(
                title: Text('${pm.report}'),
                subtitle: Text('Include Report?'),
              ),
              divider,
              ListTile(
                title: Text('\$${pm.price}',
                    style: TextStyle(color: Colors.green)),
                subtitle: Text('Price'),
              ),
              //divider,
              TextButton(
                onPressed: (() {
                  pm.serviceDate != '' ? reopenPM() :
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text('Poison Replaced:'),
                            content: FractionallySizedBox(
                                widthFactor: 0.25,
                                child: TextField(
                                  autofocus: true,
                                  keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                  textAlign: TextAlign.center,
                                  onSubmitted: (qty) {
                                    psnReplaced = qty;
                                    completePM();},
                                )),
                          ));
                }),
                child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: Colors.amber.shade600,
                    ),
                    child: Center(
                      child: Text(
                        pm.serviceDate == '' ? 'Complete PM' : 'Re-open PM',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:bugman_route/helper/sheetsAPI.dart';

class PMCard extends StatelessWidget {
  const PMCard({
    Key? key,
    required this.pm,
    required this.pmSelect,
  }) : super(key: key);

  final PM pm;
  final Function pmSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Opacity(
        opacity: pm.serviceDate != '' ? 0.5 : 1,
        child: ListTile(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          leading: pm.serviceDate != ''
              ? const Icon(Icons.check_circle_rounded, size: 16)
              : const Icon(Icons.circle, size: 16),
          title: Text('${pm.firstName} ${pm.lastName}'),
          subtitle: Text('${pm.address}'),
          trailing: Text(
            'Stns: ${pm.baitStns}',
            style: const TextStyle(fontSize: 20),
          ),
          tileColor: pm.serviceDate != ''
              ? Colors.amber.shade400
              : Colors.amber.shade600,
          onTap: (() {
            pmSelect(pm);
          }),
          //enabled: pm.serviceDate != '' ? true : false,
        ),
      ),
    );
  }
}

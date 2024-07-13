import 'package:flutter/material.dart';
import 'package:goals_ethglobal/screens/all_projects_screen.dart';

class MyDialog extends StatefulWidget {
  final List<dynamic> unstartedGoals;

  const MyDialog({super.key, required this.unstartedGoals});

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  bool isSwitched = false;
  String search = '';
  int numberC = 0;
  List<dynamic> searchPublic = [];

  @override
  Widget build(BuildContext context) {
    final List<dynamic> publicGoals =
        widget.unstartedGoals.where((element) => element[11] == true).toList();
    final List<dynamic> privateGoals =
        widget.unstartedGoals.where((element) => element[11] == false).toList();

    return AlertDialog(
      title: const Text('Search projects'),
      content: SizedBox(
        height: 150,
        child: Column(children: [
          Row(
            children: [
              Switch(
                value: isSwitched,
                onChanged: (value) => setState(() {
                  isSwitched = value;
                }),
              ),
              isSwitched ? const Text('Privates') : const Text('Publics'),
            ],
          ),
          TextFormField(
            onChanged: (value) => setState(() {
              search = value;
              numberC = search.length;
              if (isSwitched) {
                searchPublic = privateGoals
                    .where((element) =>
                        (element[12].toString().toLowerCase()) ==
                        search.toLowerCase())
                    .toList();
              } else {
                searchPublic = publicGoals
                    .where((element) =>
                        (element[1].length >= numberC
                                ? element[1].toLowerCase().substring(0, numberC)
                                : element[1].toLowerCase()) ==
                            search.toLowerCase() ||
                        (element[12].toString().length >= numberC
                                ? element[12]
                                    .toString()
                                    .toLowerCase()
                                    .substring(0, numberC)
                                : element[12].toString().toLowerCase()) ==
                            search.toLowerCase())
                    .toList();
              }
            }),
          ),
          const SizedBox(height: 10),
          isSwitched
              ? const Expanded(
                  child: Text(
                    'To find private projects, search for the project creator\'s public key (can be found on the project creator\'s profile)',
                    style: TextStyle(fontSize: 10),
                    overflow: TextOverflow.clip,
                  ),
                )
              : const SizedBox()
        ]),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return AllProjectsScreen(
                    goalsList: searchPublic,
                    title: "'$search' Projects",
                  );
                },
              ),
            );
          },
          child: const Text('Search'),
        ),
      ],
    );
  }
}

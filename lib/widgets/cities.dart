import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:drop_down_list/drop_down_list.dart';
import 'package:flutter/services.dart';

// State
import 'package:provider/provider.dart';
import '../state/applicationState.dart';

class Cities extends StatefulWidget {
  const Cities({super.key});

  @override
  State<Cities> createState() => _CitiesState();
}

class _CitiesState extends State<Cities> {
  List cityList = [];

  loadJson() async {
    // Getting Cities from assets/json/cities.json
    print('Loading Cities');
    String data = await rootBundle.loadString('assets/cities.json');
    setState(() {
      cityList = json.decode(data);
      print(cityList);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadJson();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the setCityName from ApplicationState
    var setCityName =
        Provider.of<ApplicationState>(context, listen: false).setCityName;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: DropdownButton(
            hint: Text('Select City'),
            isExpanded: true,
            iconSize: 30.0,
            style: TextStyle(color: Colors.black),
            items: cityList.map((city) {
              return DropdownMenuItem(
                child: Text(city['city']),
                value: city['city'],
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                setCityName(value as String);
              });
            },
          ),
        ),
      ],
    );
  }
}

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

  List filteredList = [];

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

    var cityNameController = TextEditingController(text: '');

    updateCityList(value) {
      print('Updating City List $value');

      setState(() {
        // filteredList = cityList;
        // cityNameController.text = value;
        filteredList = cityList.where((city) {
          return city['city'].startsWith(value);
        }).toList();
      });
      print('filtered Cities: $filteredList');
      // cityNameController.text = value;
    }

    return Column(
      children: [
        // Container(
        //   padding: EdgeInsets.all(10),
        //   child: DropdownButton(
        //     hint: Text('Select City'),
        //     isExpanded: true,
        //     iconSize: 30.0,
        //     style: TextStyle(color: Colors.black),
        //     items: cityList.map((city) {
        //       return DropdownMenuItem(
        //         child: Text(city['city']),
        //         value: city['city'],
        //       );
        //     }).toList(),
        //     onChanged: (value) {
        //       setState(() {
        //         setCityName(value as String);
        //       });
        //     },
        //   ),
        // ),

        // Autocomplete the city name from the list of cities when typing
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: TextField(
        //     controller: cityNameController,
        //     decoration: const InputDecoration(
        //       labelText: 'City Name Test',
        //       hintText: 'Enter City Name',
        //     ),
        //     onChanged: (value) {
        //       // setCityName(value);
        //       // Filter the list of cities that start with the letters typed
        //       // setState(() {
        //       // filteredList = [];
        //       // filteredList = cityList.where((city) {
        //       //   return city['city'].startsWith(value);
        //       // }).toList();
        //       // });

        //       updateCityList(value);

        //       // print(filteredList);
        //     },
        //   ),
        // ),

        // SizedBox(height: 20),
        // Text('Filtered Cities'),

        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Search for City',
              border: OutlineInputBorder(),
            ),
            child: Autocomplete(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                } else {
                  List<String> matches = <String>[];
                  matches.addAll(cityList.map((city) {
                    return '${city['city']}, ${city['state']}';
                  }));

                  matches.retainWhere((s) {
                    // print(s);
                    return s
                        .toLowerCase()
                        .startsWith(textEditingValue.text.toLowerCase());
                  });
                  return matches;
                }
              },
              onSelected: (String selection) {
                print('You just selected $selection');
                // Get the city name from the selection, just the characters to the left of the comma
                String cityName = selection.split(',')[0];
                setCityName('$cityName, US');
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    "City Name Saved!",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.orange,
                  duration: Duration(milliseconds: 1500),
                ));
              },
            ),
          ),
        )
      ],
    );
  }
}

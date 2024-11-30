// Dependencies
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';

// State
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clock/state/applicationState.dart';

class Cities extends ConsumerStatefulWidget {
  const Cities({super.key, required this.onDataChange});
  final Function() onDataChange;

  @override
  ConsumerState<Cities> createState() => _CitiesState();
}

class _CitiesState extends ConsumerState<Cities> {
  // Variables
  List cityList = [];

  loadJson() async {
    // Getting Cities from assets/json/cities.json
    String data = await rootBundle.loadString('assets/cities.json');
    setState(() {
      cityList = json.decode(data);
    });
  }

  List filteredList = [];

  // Function to set local storage using a future to eliminate file exception errors
  Future<bool> setLocalItem(localVariable, value) async {
    localStorage.setItem(localVariable, value);
    return true;
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
    return Column(
      children: [
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
                    return s
                        .toLowerCase()
                        .startsWith(textEditingValue.text.toLowerCase());
                  });
                  return matches;
                }
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  cursorColor: Theme.of(context).colorScheme.surface,
                );
              },
              onSelected: (String selection) async {
                // Get the city name from the selection, just the characters to the left of the comma
                String cityName = selection.split(',')[0];
                print('City Name: $cityName');

                // Save to local storage
                setLocalItem('city', cityName);

                // Save to state
                ref.read(applicationState.notifier).setCityName(cityName);

                // Pause 1 second
                Future.delayed(const Duration(milliseconds: 500), () {
                  print('cityName in cities: $cityName');
                  // Call the callback to update the data in the parent
                  print('calling onDataChange');
                  widget.onDataChange();
                });

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "City Name Saved!",
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    duration: const Duration(milliseconds: 1500),
                  ));
                }
              },
            ),
          ),
        )
      ],
    );
  }
}

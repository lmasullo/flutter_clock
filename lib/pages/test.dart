import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class Test extends StatefulWidget {
  const Test({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _TestState createState() => _TestState();
}

class AlarmItem {
  String title;
  bool done;

  AlarmItem({required this.title, required this.done});

  toJSONEncodable() {
    Map<String, dynamic> m = Map();

    m['title'] = title;
    m['done'] = done;

    return m;
  }
}

class TodoList {
  List<AlarmItem> items = [];

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}

class _TestState extends State<Test> {
  final TodoList list = TodoList();
  final LocalStorage storage = LocalStorage('todo_app');
  bool initialized = false;
  TextEditingController controller = TextEditingController();

  _toggleItem(AlarmItem item) {
    setState(() {
      item.done = !item.done;
      _saveToStorage();
    });
  }

  _addItem(String title) {
    setState(() {
      final item = AlarmItem(title: title, done: false);
      list.items.add(item);
      _saveToStorage();
    });
  }

  _saveToStorage() {
    storage.setItem('alarms', list.toJSONEncodable());
  }

  _clearStorage() async {
    await storage.clear();

    setState(() {
      list.items = storage.getItem('alarms') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localstorage demo'),
      ),
      body: Container(
          padding: const EdgeInsets.all(10.0),
          constraints: const BoxConstraints.expand(),
          child: FutureBuilder(
            future: storage.ready,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!initialized) {
                var items = storage.getItem('alarms');

                if (items != null) {
                  list.items = List<AlarmItem>.from(
                    (items as List).map(
                      (item) => AlarmItem(
                        title: item['title'],
                        done: item['done'],
                      ),
                    ),
                  );
                }

                initialized = true;
              }

              List<Widget> widgets = list.items.map((item) {
                return CheckboxListTile(
                  value: item.done,
                  title: Text(item.title),
                  selected: item.done,
                  onChanged: (_) {
                    _toggleItem(item);
                  },
                );
              }).toList();

              return Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: ListView(
                      children: widgets,
                      itemExtent: 50.0,
                    ),
                  ),
                  ListTile(
                    title: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        labelText: 'What to do?',
                      ),
                      onEditingComplete: _save,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.save),
                          onPressed: _save,
                          tooltip: 'Save',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: _clearStorage,
                          tooltip: 'Clear storage',
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          )),
    );
  }

  void _save() {
    _addItem(controller.value.text);
    controller.clear();
  }
}

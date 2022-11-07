// Dependencies
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

// State
import 'package:provider/provider.dart';
import '../state/applicationState.dart';

// Pages
import 'pages/settings.dart';

// Widgets
import 'widgets/clock.dart';
import 'widgets/brightness.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
  //   SystemUiOverlay.bottom, //This line is used for showing the bottom bar
  //   // SystemUiOverlay.top //This line is used for showing the top bar
  // ]);

  // Remove the status and bottom bars
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  runApp(
    // This is enables Provider State Management
    ChangeNotifierProvider(
        create: (context) => ApplicationState(),
        builder: (context, _) => const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<int, Color> color1 = {
      50: const Color(0xFFE8E5E5),
      100: const Color(0xFFC5BEBE),
      200: const Color(0xFF9E9393),
      300: const Color(0xFF776868),
      400: const Color(0xFF594747),
      500: const Color(0xFF3C2727),
      600: const Color(0xFF362323),
      700: const Color(0xFF2E1D1D),
      800: const Color(0xFF271717),
      900: const Color(0xFF1A0E0E),
    };

    const int clockPrimaryValue = 0xFF271717;

    return MaterialApp(
      title: 'Snooze',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: MaterialColor(clockPrimaryValue, color1),
      ),
      home: const MyHomePage(title: 'Snooze'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // Variable fort the title of the app
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    // Keep the app awake
    Wakelock.enable();

    // Remove the status and bottom bars
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: [SystemUiOverlay.bottom]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Color(0xFF3C2727),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.c,
        children: const <Widget>[
          // The brightness widget
          Brightness(),
          // The clock widget
          Clock(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: const Color(0xFF594747),
        backgroundColor: const Color(0xFF362323),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Settings()),
          );
        },
        tooltip: 'Settings',
        child: const Icon(Icons.settings),
      ),
    );
  }
}

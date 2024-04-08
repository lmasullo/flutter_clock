// Dependencies
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

// State
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Pages
import 'pages/settings.dart';

// Widgets
import 'widgets/clock.dart';
import 'widgets/brightnessSlider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Remove the status and bottom bars
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  runApp(
    // This is enables Riverpod State Management
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snooze',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.black,
          onPrimary: Colors.white,
          secondary: Colors.grey,
          onSecondary: Colors.green,
          surface: Colors.red,
          onSurface: Colors.white,
          error: Colors.red,
          onError: Colors.white,
        ),
      ),
      home: const MyHomePage(title: 'Snooze'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  // Variable fort the title of the app
  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  // Variables
  // void rebuild() {
  //   print('rebuilding on Main');
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();

    // Keep the app awake
    Wakelock.enable();

    // Remove the status and bottom bars
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // The brightness widget
            BrightnessSlider(),
            // The clock widget
            Clock(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Theme.of(context).colorScheme.secondary,
        backgroundColor: Theme.of(context).colorScheme.surface,
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

import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

void main(List<String> args) {
  runApp(const MaterialApp(
      home: BottomNavigationPage(
    initialIndex: 0,
    views: [
      // BottomNavigationView(
      //     title: 'Work',
      //     label: 'Work',
      //     view: Center(child: Text('Work')),
      //     icon: Icons.work,
      //     actionIcon: Icons.add,
      //     action: null),
      // BottomNavigationView(
      //     title: 'Work',
      //     label: 'Work',
      //     view: Center(child: Text('Work')),
      //     icon: Icons.work,
      //     actionIcon: Icons.add,
      //     action: null),
      // BottomNavigationView(
      //     title: 'Work',
      //     label: 'Work',
      //     view: Center(child: Text('Work')),
      //     icon: Icons.work,
      //     actionIcon: Icons.add,
      //     action: null),
    ],
  )));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  TextFieldController controller = TextFieldController('Niggi');

  Function() listener = () {};

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(listener);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:myapp/Recreateanimation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Person Profile App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AboutPersonPage(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:myapp/egAnimationSwitcher.dart';

// // Main function to run the app
// void main() {
//   runApp(MyApp());
// }

// // Root widget of the application
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'AnimatedSwitcher Demo',
//       home: Scaffold(
//         appBar: AppBar(title: Text('AnimatedSwitcher Demo')),
//         body: Center(
//           child: SwitcherWidgetDemo(), // Use our custom widget
//         ),
//       ),
//     );
//   }
// }

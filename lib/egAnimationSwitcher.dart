// The StatefulWidget that manages the switching
import 'package:flutter/material.dart';

class SwitcherWidgetDemo extends StatefulWidget {
  @override
  _SwitcherWidgetDemoState createState() => _SwitcherWidgetDemoState();
}

// The State class for SwitcherWidgetDemo
class _SwitcherWidgetDemoState extends State<SwitcherWidgetDemo> {
  // State variable to track which widget to show
  bool _showFirstWidget = true;

  // --- Define the two widgets to switch between ---

  // Widget 1
  final Widget _firstWidget = Container(
    // *** Add a Key! *** This is crucial for AnimatedSwitcher
    key: const ValueKey(1), // Unique key for this widget
    width: 200.0,
    height: 200.0,
    color: Colors.teal,
    child: const Center(
      child: Text(
        'Widget 1',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  // Widget 2
  final Widget _secondWidget = Container(
    // *** Add a Key! *** This is crucial for AnimatedSwitcher
    key: const ValueKey(2), // Unique key for this widget
    width: 150.0,
    height: 100.0,
    color: Colors.orange,
    child: const Center(child: Icon(Icons.star, color: Colors.white, size: 50)),
  );

  // --- Animation Duration ---
  final Duration _animationDuration = Duration(
    milliseconds: 500,
  ); // 0.5 seconds

  // Function to toggle the state
  void _toggleWidget() {
    setState(() {
      // Flip the boolean value
      _showFirstWidget = !_showFirstWidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
      children: <Widget>[
        // The AnimatedSwitcher
        AnimatedSwitcher(
          // Define how long the transition animation should take
          duration: _animationDuration,

          // --- Define the transition ---
          // This builder function defines how the widgets fade/slide/scale etc.
          transitionBuilder: (Widget child, Animation<double> animation) {
            // Use FadeTransition for a simple fade in/out effect
            return FadeTransition(
              opacity: animation, // The animation drives the opacity
              child: child, // The incoming or outgoing child
            );
            // You could use other transitions like ScaleTransition:
            // return ScaleTransition(scale: animation, child: child);
          },

          // --- The child widget ---
          // This changes based on our state variable.
          // AnimatedSwitcher detects the change because the Keys are different.
          child: _showFirstWidget ? _firstWidget : _secondWidget,
        ),
        SizedBox(height: 30), // Add some space
        // Button to trigger the state change
        ElevatedButton(
          onPressed: _toggleWidget, // Call our toggle function
          child: Text('Switch Widget'),
        ),
      ],
    );
  }
}

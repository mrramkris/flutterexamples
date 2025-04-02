import 'package:flutter/material.dart';

// Enum to represent the different transition types we'll demonstrate
enum TransitionType {
  fade,
  scale,
  rotation,
  size,
  slideRight,
  slideUp,
  decoratedBox,
  align,
  // PositionedTransition & RelativePositionedTransition require a Stack,
  // DefaultTextStyleTransition applies to text style down the tree.
  // These are omitted here for simplicity but follow similar patterns using tweens.
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Transitions Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo, // Changed theme for better contrast maybe
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('AnimatedSwitcher Transitions')),
        body: TransitionGallery(),
      ),
    );
  }
}

class TransitionGallery extends StatefulWidget {
  @override
  _TransitionGalleryState createState() => _TransitionGalleryState();
}

class _TransitionGalleryState extends State<TransitionGallery> {
  // State for which widget is shown
  bool _showFirstWidget = true;
  // State for the selected transition type
  TransitionType _selectedTransition =
      TransitionType.fade; // Default transition

  // --- Define the two widgets to switch between ---
  final Widget _firstWidget = Container(
    key: const ValueKey(1), // Unique key
    width: 250.0,
    height: 250.0,
    decoration: BoxDecoration(
      color: Colors.deepPurpleAccent,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: const Center(
      child: Text(
        'Widget One',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  final Widget _secondWidget = Container(
    key: const ValueKey(2), // Unique key
    width: 200.0,
    height: 200.0,
    decoration: BoxDecoration(
      color: Colors.amber,
      shape: BoxShape.circle, // Different shape
      border: Border.all(color: Colors.black, width: 3),
    ),
    child: const Center(child: Icon(Icons.star, color: Colors.white, size: 80)),
  );

  // --- Define decorations for DecoratedBoxTransition ---
  final Decoration _firstDecoration = BoxDecoration(
    color: Colors.lightGreen,
    borderRadius: BorderRadius.circular(10),
  );
  final Decoration _secondDecoration = BoxDecoration(
    color: Colors.redAccent,
    shape: BoxShape.rectangle, // Will animate to rectangle
    gradient: LinearGradient(
      colors: [Colors.redAccent, Colors.orangeAccent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  // --- Define alignments for AlignTransition ---
  final AlignmentGeometry _firstAlignment = Alignment.centerLeft;
  final AlignmentGeometry _secondAlignment = Alignment.centerRight;

  // --- Animation Duration ---
  final Duration _animationDuration = Duration(milliseconds: 600);

  // Function to toggle the widget
  void _toggleWidget() {
    setState(() {
      _showFirstWidget = !_showFirstWidget;
    });
  }

  // --- Dynamic Transition Builder ---
  Widget _buildTransition(Widget child, Animation<double> animation) {
    // Use a Tween to drive specific transitions if needed
    // (e.g., for SlideTransition, DecoratedBoxTransition, AlignTransition)

    switch (_selectedTransition) {
      case TransitionType.scale:
        return ScaleTransition(
          scale: animation, // Use the default 0.0-1.0 animation directly
          child: child,
        );

      case TransitionType.rotation:
        return RotationTransition(
          turns: animation, // Use the default 0.0-1.0 animation for a full turn
          child: child,
        );

      case TransitionType.size:
        // Often used with ClipRect for better visual effect
        return ClipRect(
          child: SizeTransition(
            sizeFactor: animation, // Default animation
            axis: Axis.horizontal, // Animate width
            axisAlignment: -1.0, // Grow from left-to-right
            child: child,
          ),
        );

      case TransitionType.slideRight:
        // Need Animation<Offset>. Create from default Animation<double>
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(-1.0, 0.0), // Start off-screen left
          end: Offset.zero, // End at original position
        ).animate(animation); // Use the default animation curve
        // For slide-out, AnimatedSwitcher handles it automatically
        // based on how the child leaves.
        return SlideTransition(position: offsetAnimation, child: child);

      case TransitionType.slideUp:
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0.0, 1.0), // Start off-screen bottom
          end: Offset.zero,
        ).animate(animation);
        return SlideTransition(position: offsetAnimation, child: child);

      case TransitionType.decoratedBox:
        // Need Animation<Decoration>. Create using DecorationTween.
        // Note: The 'child' passed here is the *content* of the box,
        // so we wrap it in a DecoratedBox.
        // The key needs to be on the DecoratedBox for the switcher to notice.
        final decorationAnimation = DecorationTween(
          begin: _showFirstWidget ? _firstDecoration : _secondDecoration,
          end: _showFirstWidget ? _secondDecoration : _firstDecoration,
        ).animate(animation);
        // Important: Need to return the correct child based on state
        Widget currentChildContent =
            _showFirstWidget
                ? (_firstWidget as Container).child!
                : (_secondWidget as Container).child!;
        Key currentKey =
            _showFirstWidget ? _firstWidget.key! : _secondWidget.key!;

        // The AnimatedSwitcher child *must* be the DecoratedBoxTransition itself
        // or have the key so it knows what changed. Simpler to animate content inside.
        // Let's reconsider: Simpler to make the *child* of AnimatedSwitcher
        // the thing being decorated.

        // Alternative approach (simpler for standard setup):
        // Have the AnimatedSwitcher switch between two DecoratedBoxes.
        // This example will just animate the decoration *within* the builder.
        // It might not look perfect depending on widget structure.
        // A more robust way is to put DecoratedBox *inside* _firstWidget/_secondWidget
        // and use AnimatedContainer, or make the AnimatedSwitcher's child
        // a DecoratedBoxTransition whose child is simpler.
        // Sticking to the builder method for consistency:
        return DecoratedBoxTransition(
          decoration: decorationAnimation,
          child: Container(
            // Need a container to give it size
            width: 200,
            height: 200,
            alignment: Alignment.center,
            child: child, // Put the original child inside
          ),
        );

      // case TransitionType.align:
      //   // Need Animation<AlignmentGeometry>
      //   final alignAnimation = AlignmentGeometryTween(
      //     begin: _showFirstWidget ? _firstAlignment : _secondAlignment,
      //     end: _showFirstWidget ? _secondAlignment : _firstAlignment,
      //   ).animate(animation);
      //   // Wrap the child in an AlignTransition
      //   return AlignTransition(
      //     alignment: alignAnimation as Animation<AlignmentGeometry>,
      //     child: child,
      //   );

      case TransitionType.fade:
      default: // Default to FadeTransition
        return FadeTransition(
          opacity: animation, // Use the default 0.0-1.0 animation
          child: child,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the correct child widget based on the state
    Widget currentWidget = _showFirstWidget ? _firstWidget : _secondWidget;

    // Special handling for DecoratedBoxTransition: child must be consistent
    // if we animate decoration in the builder as above.
    // A cleaner way is to switch between two *different* DecoratedBox widgets.
    // Let's switch the whole widget instead for DecoratedBox and Align.
    if (_selectedTransition == TransitionType.decoratedBox) {
      currentWidget = DecoratedBox(
        key: ValueKey(_showFirstWidget ? 'box1' : 'box2'),
        decoration: _showFirstWidget ? _firstDecoration : _secondDecoration,
        child: Container(
          width: 200,
          height: 200,
          alignment: Alignment.center,
          child: Text(
            _showFirstWidget ? "Decorated 1" : "Decorated 2",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else if (_selectedTransition == TransitionType.align) {
      // Child needs to be consistent for AlignTransition if done in builder.
      // Simpler to switch between two Aligned widgets.
      currentWidget = Align(
        key: ValueKey(_showFirstWidget ? 'align1' : 'align2'),
        alignment: _showFirstWidget ? _firstAlignment : _secondAlignment,
        child: Container(
          // Give it something visible
          width: 100,
          height: 100,
          color: _showFirstWidget ? Colors.cyan : Colors.pink,
          child: Center(
            child: Text(_showFirstWidget ? "Aligned 1" : "Aligned 2"),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Dropdown to select transition
          DropdownButton<TransitionType>(
            value: _selectedTransition,
            onChanged: (TransitionType? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedTransition = newValue;
                });
              }
            },
            items:
                TransitionType.values.map<DropdownMenuItem<TransitionType>>((
                  TransitionType value,
                ) {
                  return DropdownMenuItem<TransitionType>(
                    value: value,
                    child: Text(
                      value.toString().split('.').last,
                    ), // Show enum name
                  );
                }).toList(),
          ),
          const SizedBox(height: 20),

          // The AnimatedSwitcher using the dynamic transition builder
          Expanded(
            // Give AnimatedSwitcher space to work
            child: Center(
              // Center the switcher content
              child: AnimatedSwitcher(
                duration: _animationDuration,
                // Assign our dynamic builder function
                transitionBuilder: _buildTransition,
                // The child changes based on _showFirstWidget state
                // Key is important here! It's on the _firstWidget/_secondWidget
                child: currentWidget, // Use the determined widget
                // Optional: Define layout behavior during transition
                layoutBuilder: (
                  Widget? currentChild,
                  List<Widget> previousChildren,
                ) {
                  return Stack(
                    children: <Widget>[
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                    alignment:
                        Alignment.center, // Keep centered during transition
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 20),
          // Button to trigger the switch
          ElevatedButton(
            onPressed: _toggleWidget,
            child: const Text('Switch Widget'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

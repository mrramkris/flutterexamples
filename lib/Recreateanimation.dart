import 'package:flutter/material.dart';

class AboutPersonPage extends StatefulWidget {
  const AboutPersonPage({super.key});

  @override
  State<AboutPersonPage> createState() => _AboutPersonPageState();
}

class _AboutPersonPageState extends State<AboutPersonPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _aboutMeController = TextEditingController();
  bool _isEditingAboutMe = false;
  bool _showDemographics = false;
  final List<String> _selectedDemographics = [];
  late AnimationController _animationController;
  late Animation<double> _animation;

  // --- Animation Duration ---
  final Duration _animationDuration = Duration(
    milliseconds: 500,
  ); // 0.5 seconds

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCirc,
    );
  }

  @override
  void dispose() {
    _aboutMeController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleEditAboutMe() {
    setState(() {
      _isEditingAboutMe = !_isEditingAboutMe;
    });
  }

  void _toggleDemographics() {
    setState(() {
      _showDemographics = !_showDemographics;
      if (_showDemographics) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _selectDemographic(String demographic) {
    setState(() {
      if (_selectedDemographics.contains(demographic)) {
        _selectedDemographics.remove(demographic);
      } else {
        _selectedDemographics.add(demographic);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Person'),
        toolbarHeight: 36,
        backgroundColor: Colors.green.shade200,

        // actions: [
        //   IconButton(
        //     icon: Icon(_showDemographics ? Icons.close : Icons.edit),
        //     onPressed: _toggleDemographics,
        //   ),
        // ],
      ),
      body:
      // Stack(
      //   children: [
      //     _buildAboutPersonContent(),
      //     if (_showDemographics) _buildDemographicsSelection(),
      //   ],
      // ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start, // Center content vertically
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
            child:
                _showDemographics
                    ? _buildAboutPersonContent()
                    : _buildDemographicsSelection(),
          ),
          // SizedBox(height: 30), // Add some space
          // // Button to trigger the state change
          // ElevatedButton(
          //   onPressed: _toggleWidget, // Call our toggle function
          //   child: Text('Switch Widget'),
          // ),
        ],
      ),
    );
  }

  Widget _buildAboutPersonContent() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Person Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'About Me',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                    _isEditingAboutMe ? Icons.save : Icons.edit,
                    color: Colors.blue,
                  ),
                  onPressed: _toggleEditAboutMe,
                ),
              ],
            ),
            const SizedBox(height: 8),
            _isEditingAboutMe
                ? TextField(
                  controller: _aboutMeController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                )
                : Text(
                  _aboutMeController.text.isEmpty
                      ? 'No description provided.'
                      : _aboutMeController.text,
                ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  _isEditingAboutMe ? Icons.save : Icons.edit,
                  color: Colors.blue,
                ),
                onPressed: _toggleEditAboutMe,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Demographics',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: _toggleDemographics,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children:
                  _selectedDemographics.map((demographic) {
                    return Chip(label: Text(demographic));
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemographicsSelection() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Demographics',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDemographicOption('Gender'),
            _buildDemographicOption('Age'),
            _buildDemographicOption('Profession'),
            _buildDemographicOption('Working Holiday'),
            _buildDemographicOption('Backpacker'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _toggleDemographics,
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemographicOption(String demographic) {
    return CheckboxListTile(
      title: Text(demographic),
      value: _selectedDemographics.contains(demographic),
      onChanged: (bool? value) {
        _selectDemographic(demographic);
      },
    );
  }
}

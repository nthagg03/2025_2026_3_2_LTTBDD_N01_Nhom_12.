import 'package:flutter/material.dart';

class HomeWidgetPage extends StatefulWidget {
  const HomeWidgetPage({super.key});

  @override
  State<HomeWidgetPage> createState() => _HomeWidgetPageState();
}

class _HomeWidgetPageState extends State<HomeWidgetPage> {
  String _latestPhoto = 'Latest photo: Summer trip';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Widget')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(Icons.image, size: 72, color: Colors.deepPurple),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _latestPhoto,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text('This is the widget preview for the newest photo.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _latestPhoto = 'Latest photo: Updated from refresh';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Widget data refreshed')),
                  );
                },
                child: const Text('Refresh widget data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

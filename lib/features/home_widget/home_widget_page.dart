import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

class HomeWidgetPage extends StatefulWidget {
  const HomeWidgetPage({super.key});

  @override
  State<HomeWidgetPage> createState() => _HomeWidgetPageState();
}

class _HomeWidgetPageState extends State<HomeWidgetPage> {
  String _latestPhoto = 'Latest photo: Summer trip';

  @override
  void initState() {
    super.initState();
    _loadSavedWidgetData();
  }

  Future<void> _loadSavedWidgetData() async {
    final savedValue = await HomeWidget.getWidgetData<String>(
      'latest_photo',
      defaultValue: 'Latest photo: Summer trip',
    );
    if (!mounted) return;
    setState(() {
      _latestPhoto = savedValue ?? 'Latest photo: Summer trip';
    });
  }

  Future<void> _refreshWidgetData() async {
    final nextValue = 'Latest photo: Updated from refresh';
    setState(() {
      _latestPhoto = nextValue;
    });

    await HomeWidget.saveWidgetData<String>('latest_photo', nextValue);
    await HomeWidget.saveWidgetData<String>(
      'latest_photo_title',
      'Newest photo',
    );
    await HomeWidget.updateWidget(
      name: 'HomeWidgetProvider',
      iOSName: 'HomeWidget',
    );

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Widget data refreshed')));
  }

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
                onPressed: _refreshWidgetData,
                child: const Text('Refresh widget data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
